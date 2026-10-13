import { type Plugin, tool } from "@opencode-ai/plugin"
import { mkdir, readdir, readFile, writeFile } from "node:fs/promises"
import { homedir } from "node:os"
import { join } from "node:path"

const NOTES_DIR =
  process.env.OPENCODE_RAG_NOTES_DIR ?? join(homedir(), ".nb", "home")
const CACHE_DIR =
  process.env.OPENCODE_RAG_CACHE_DIR ?? join(homedir(), ".cache", "opencode-rag")
const INDEX_PATH = join(CACHE_DIR, "nb-index.json")
const OLLAMA_URL = process.env.OPENCODE_RAG_OLLAMA ?? "http://localhost:11434"
const MODEL = process.env.OPENCODE_RAG_MODEL ?? "bge-m3"
const CHUNK_SIZE = 600
const BATCH = 32

type Entry = { file: string; heading: string; text: string; vec: number[] }
type Index = {
  model: string
  dim: number
  generatedAt: string
  entries: Entry[]
}

function shortPath(path: string): string {
  const home = homedir()
  return path.startsWith(home) ? `~${path.slice(home.length)}` : path
}

async function walk(dir: string, out: string[] = []): Promise<string[]> {
  let items
  try {
    items = await readdir(dir, { withFileTypes: true })
  } catch {
    return out
  }
  for (const item of items) {
    if (item.name.startsWith(".")) continue
    const full = join(dir, item.name)
    if (item.isDirectory()) {
      await walk(full, out)
      continue
    }
    if (!item.name.endsWith(".md")) continue
    if (
      item.name.startsWith("#") ||
      item.name.endsWith("#") ||
      item.name.endsWith("~")
    ) {
      continue
    }
    out.push(full)
  }
  return out
}

function stripFrontmatter(text: string): string {
  if (!text.startsWith("---")) return text
  const end = text.indexOf("\n---", 3)
  if (end === -1) return text
  const nl = text.indexOf("\n", end + 1)
  return nl === -1 ? "" : text.slice(nl + 1)
}

function chunkMarkdown(raw: string): { heading: string; text: string }[] {
  const text = stripFrontmatter(raw)
  const chunks: { heading: string; text: string }[] = []
  let heading = ""
  let buf: string[] = []
  let len = 0
  const flush = () => {
    const body = buf.join("\n").trim()
    if (body) chunks.push({ heading, text: body })
    buf = []
    len = 0
  }
  for (const line of text.split("\n")) {
    const h = /^(#{1,6})\s+(.*)$/.exec(line)
    if (h) {
      flush()
      heading = h[2].trim()
      continue
    }
    if (line.trim() === "") {
      buf.push("")
      if (len >= CHUNK_SIZE) flush()
      continue
    }
    buf.push(line)
    len += line.length
    if (len >= CHUNK_SIZE) flush()
  }
  flush()
  return chunks
}

async function embed(texts: string[]): Promise<number[][]> {
  try {
    const res = await fetch(`${OLLAMA_URL}/api/embed`, {
      method: "POST",
      headers: { "content-type": "application/json" },
      body: JSON.stringify({ model: MODEL, input: texts }),
    })
    if (res.ok) {
      const data = (await res.json()) as { embeddings?: number[][] }
      if (Array.isArray(data.embeddings)) return data.embeddings
    }
  } catch {
    // fall through to the single-prompt endpoint
  }
  const out: number[][] = []
  for (const text of texts) {
    const res = await fetch(`${OLLAMA_URL}/api/embeddings`, {
      method: "POST",
      headers: { "content-type": "application/json" },
      body: JSON.stringify({ model: MODEL, prompt: text }),
    })
    if (!res.ok) {
      throw new Error(`ollama ${res.status}: ${await res.text()}`)
    }
    const data = (await res.json()) as { embedding: number[] }
    out.push(data.embedding)
  }
  return out
}

function cosine(a: number[], b: number[]): number {
  let dot = 0
  let na = 0
  let nb = 0
  const n = Math.min(a.length, b.length)
  for (let i = 0; i < n; i++) {
    dot += a[i] * b[i]
    na += a[i] * a[i]
    nb += b[i] * b[i]
  }
  if (na === 0 || nb === 0) return 0
  return dot / (Math.sqrt(na) * Math.sqrt(nb))
}

function snippet(text: string, max = 300): string {
  const flat = text.replace(/\s+/g, " ").trim()
  return flat.length > max ? `${flat.slice(0, max)}…` : flat
}

async function loadIndex(): Promise<Index | null> {
  try {
    return JSON.parse(await readFile(INDEX_PATH, "utf8")) as Index
  } catch {
    return null
  }
}

export const NotesRag: Plugin = async () => {
  return {
    tool: {
      notes_reindex: tool({
        description:
          "住宅のノート (~/.nb/home) を ollama の埋め込み (bge-m3) でベクトル化し、ローカル検索インデックスを再生成する。初回やノートを大量に追加した後に実行する。",
        args: {},
        async execute() {
          const files = await walk(NOTES_DIR)
          if (files.length === 0) {
            return `ノートが見つかりませんでした: ${shortPath(NOTES_DIR)}`
          }
          const meta: { file: string; heading: string; text: string }[] = []
          for (const file of files) {
            const raw = await readFile(file, "utf8")
            for (const chunk of chunkMarkdown(raw)) {
              meta.push({ file, heading: chunk.heading, text: chunk.text })
            }
          }
          const entries: Entry[] = []
          for (let i = 0; i < meta.length; i += BATCH) {
            const slice = meta.slice(i, i + BATCH)
            const inputs = slice.map((c) =>
              c.heading ? `${c.heading}\n${c.text}` : c.text,
            )
            let vecs: number[][]
            try {
              vecs = await embed(inputs)
            } catch (error) {
              return `埋め込みに失敗しました。ollama が起動しているか確認してください (ollama serve / ollama pull ${MODEL}): ${error}`
            }
            slice.forEach((chunk, j) =>
              entries.push({
                ...chunk,
                vec: (vecs[j] ?? []).map((n) => Math.round(n * 1e5) / 1e5),
              }),
            )
          }
          const index: Index = {
            model: MODEL,
            dim: entries[0]?.vec.length ?? 0,
            generatedAt: new Date().toISOString(),
            entries,
          }
          await mkdir(CACHE_DIR, { recursive: true })
          await writeFile(INDEX_PATH, JSON.stringify(index))
          return `インデックス生成完了: ${entries.length} チャンク / ${files.length} ファイル, dim=${index.dim}, 保存先=${shortPath(INDEX_PATH)}`
        },
      }),
      notes_search: tool({
        description:
          "ユーザーの個人ノート (~/.nb/home) を意味検索する。過去の考え・日記・メモ・文体サンプルを参照したいときに使う。関連するチャンクをファイルパス付きで返す。",
        args: {
          query: tool.schema.string().describe("検索クエリ（日本語可）"),
          k: tool.schema
            .number()
            .optional()
            .describe("返す件数（既定 8）"),
        },
        async execute(args) {
          const index = await loadIndex()
          if (!index || index.entries.length === 0) {
            return `インデックスがありません。先に notes_reindex を実行してください (${shortPath(INDEX_PATH)})`
          }
          let queryVec: number[]
          try {
            queryVec = (await embed([args.query]))[0]
          } catch (error) {
            return `クエリの埋め込みに失敗しました。ollama が起動しているか確認してください: ${error}`
          }
          const k = args.k ?? 8
          const scored = index.entries
            .map((entry) => ({ entry, score: cosine(queryVec, entry.vec) }))
            .sort((a, b) => b.score - a.score)
            .slice(0, k)
          if (scored.length === 0) return "該当するノートは見つかりませんでした。"
          return scored
            .map(({ entry, score }, i) => {
              const head = entry.heading ? ` ## ${entry.heading}` : ""
              return `${i + 1}. [${score.toFixed(3)}] ${shortPath(entry.file)}${head}\n${snippet(entry.text)}`
            })
            .join("\n\n")
        },
      }),
    },
  }
}
