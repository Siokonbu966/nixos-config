import type { Plugin } from "@opencode-ai/plugin"
import { validateCommitMessage } from "./commit-message"

const PROTECTED = new Set(["main", "master", "HEAD"])

const CONVENTION = [
  "You write git commit messages.",
  "Return EXACTLY one line. No quotes, no markdown, no code fences, no explanation.",
  "Format: <type>[optional scope]: <description>",
  "type is one of: feat, fix, docs, build, chore, ci, refactor, test, perf, style, revert.",
  "Use the imperative mood in English, lowercase first letter, no trailing period.",
  "When useful, pick a scope from the changed paths (e.g. opencode, nix, home, modules, pkgs, configs, or a host name).",
  "Do not use any tools. Only use the diff provided below.",
].join("\n")

export const AutoCommit: Plugin = async ({ directory, worktree, client, $ }) => {
  const cwd = worktree || directory
  const spawned = new Set<string>()
  let running = false
  let model: { providerID: string; modelID: string } | null = null
  let modelLoaded = false

  const log = async (level: "debug" | "info" | "warn" | "error", message: string) => {
    try {
      await client.app.log({ body: { service: "auto-commit", level, message } })
    } catch {}
  }

  const toast = async (message: string, variant: "info" | "success" | "warning" | "error") => {
    try {
      await client.tui.showToast({ body: { message, variant } })
    } catch {}
  }

  const getModel = async () => {
    if (modelLoaded) return model
    modelLoaded = true
    try {
      const res: any = await client.config.get()
      const cfg: any = res?.data ?? res ?? {}
      const spec: string = cfg.small_model ?? ""
      const [providerID, ...rest] = spec.split("/")
      const modelID = rest.join("/")
      if (providerID && modelID) model = { providerID, modelID }
    } catch {}
    return model
  }

  const generateMessage = async (diff: string): Promise<string | null> => {
    const clipped = diff.length > 8000 ? diff.slice(0, 8000) + "\n...(truncated)" : diff
    const text = CONVENTION + "\n\nDiff:\n" + clipped
    try {
      const created: any = await client.session.create({ body: { title: "auto-commit" } })
      const id: string | undefined = created?.data?.id ?? created?.id
      if (!id) return null
      spawned.add(id)
      const m = await getModel()
      const body: any = { parts: [{ type: "text", text }] }
      if (m) body.model = m
      const res: any = await client.session.prompt({ path: { id }, body })
      const data: any = res?.data ?? res
      const parts: any[] = data?.parts ?? []
      const out = parts
        .filter((p) => p?.type === "text")
        .map((p) => p.text ?? "")
        .join("\n")
        .trim()
      client.session.delete({ path: { id } }).catch(() => {})
      const cleaned = out.replace(/^["'`]+|["'`]+$/g, "").trim()
      const validationError = validateCommitMessage(cleaned)
      if (validationError) {
        await log("warn", "generated commit message rejected: " + validationError)
        return null
      }
      return cleaned
    } catch (err) {
      await log("warn", "message generation failed: " + String(err))
      return null
    }
  }

  const fallbackMessage = (status: string): string => {
    const paths = status
      .split("\n")
      .map((l) => l.slice(3).trim())
      .filter(Boolean)
    const first = paths[0] ?? ""
    const seg = first.split("/")[0] ?? ""
    const scope =
      seg === "flake.nix" || seg === "flake.lock" ? "nix" : seg.replace(/[^a-z0-9_-]/gi, "") || "nix"
    return "chore(" + scope + "): update files"
  }

  const run = async () => {
    const branch = (
      await $`git rev-parse --abbrev-ref HEAD`.cwd(cwd).quiet().nothrow().text()
    ).trim()
    if (!branch || PROTECTED.has(branch)) return

    const statusResult = await $`git status --porcelain`.cwd(cwd).quiet().nothrow()
    if (statusResult.exitCode !== 0) {
      await log("warn", "could not inspect worktree status")
      return
    }
    const status = statusResult.text().trim()
    if (!status) return

    const addResult = await $`git add -A`.cwd(cwd).quiet().nothrow()
    if (addResult.exitCode !== 0) {
      await log("error", "git add failed: " + addResult.stderr.toString())
      await toast("auto-commit: git add failed", "error")
      return
    }

    const diffResult = await $`git diff --cached`.cwd(cwd).quiet().nothrow()
    if (diffResult.exitCode !== 0) {
      await log("error", "could not inspect staged diff: " + diffResult.stderr.toString())
      return
    }
    const diff = diffResult.text()
    if (!diff.trim()) return

    const generatedMessage = await generateMessage(diff)
    const message = generatedMessage ?? fallbackMessage(status)
    const validationError = validateCommitMessage(message)
    if (validationError) {
      await log("error", "commit message rejected: " + validationError)
      await toast("auto-commit skipped: invalid commit message", "warning")
      return
    }

    const commitResult = await $`git commit -m ${message}`.cwd(cwd).quiet().nothrow()
    if (commitResult.exitCode !== 0) {
      const output = commitResult.stderr.toString() || commitResult.text()
      if (output.includes("nothing to commit")) return
      await log("error", "git commit failed: " + output.trim())
      await toast("auto-commit failed", "error")
      return
    }

    await log("info", "auto-committed on " + branch + ": " + message)
    await toast("auto-commit: " + message, "success")
  }

  const isTeachSession = async (sessionID: string): Promise<boolean> => {
    try {
      const res: any = await client.session.get({ path: { id: sessionID } })
      const session: any = res?.data ?? res
      return session?.agent === "teach"
    } catch {
      return false
    }
  }

  return {
    event: async ({ event }) => {
      if (!event || event.type !== "session.idle") return
      const props: any = (event as any).properties ?? {}
      const sid: string | undefined = props.sessionID ?? props.session?.id ?? props.info?.id
      if (sid && spawned.has(sid)) return
      if (sid && (await isTeachSession(sid))) return
      if (running) return
      running = true
      try {
        await run()
      } catch (err) {
        await log("error", "auto-commit failed: " + String(err))
      } finally {
        running = false
      }
    },
  }
}
