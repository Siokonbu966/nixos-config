import type { Plugin } from "@opencode-ai/plugin"
import { link, mkdir, open, readFile, unlink } from "node:fs/promises"
import { randomUUID } from "node:crypto"
import path from "node:path"

const PROTECTED_BRANCHES = new Set(["main", "master"])
const FILE_EDIT_TOOLS = new Set(["edit", "write", "apply_patch"])
const MUTATING_BASH = [
  /\bgit(?:\s+-C\s+\S+)?\s+(?:apply|am|cherry-pick|commit|merge|rebase|reset|restore|revert|checkout|stash)\b/,
  /(?:^|[;&|]\s*)(?:cp|dd|install|ln|mkdir|mv|rm|rmdir|tee|touch|truncate)\b/,
  /\b(?:perl|sed)\b[^;&|]*\s-i(?:\s|$)/,
  /(?:^|[;&|]\s*)[^;&|]*\s>>?\s*\S+/,
]

export const isMutatingBash = (command: string) =>
  MUTATING_BASH.some((pattern) => pattern.test(command))

export class WorktreeOwnedByAnotherSessionError extends Error {
  constructor(ownerSessionID: string) {
    super(
      `このworktreeは別のOpenCodeセッション (${ownerSessionID}) に割り当て済みです。` +
        `タスクごとに別のworktreeを作成してから作業してください。`,
    )
    this.name = "WorktreeOwnedByAnotherSessionError"
  }
}

const isAlreadyExists = (error: unknown) =>
  typeof error === "object" &&
  error !== null &&
  "code" in error &&
  error.code === "EEXIST"

/** Atomically assign a Git worktree to one root OpenCode session. */
export async function claimWorktree(
  gitDirectory: string,
  worktree: string,
  rootSessionID: string,
): Promise<void> {
  const lockDirectory = path.join(gitDirectory, "opencode-worktree-guard")
  const lockPath = path.join(lockDirectory, "owner.json")
  await mkdir(lockDirectory, { recursive: true, mode: 0o700 })

  const temporaryPath = `${lockPath}.${process.pid}.${randomUUID()}.tmp`
  const record = JSON.stringify({ worktree, rootSessionID })
  try {
    const lock = await open(temporaryPath, "wx", 0o600)
    try {
      await lock.writeFile(record, "utf8")
    } finally {
      await lock.close()
    }
    try {
      // Publish only a complete record, without replacing another session's claim.
      await link(temporaryPath, lockPath)
      return
    } catch (error) {
      if (!isAlreadyExists(error)) throw error
    } finally {
      await unlink(temporaryPath).catch(() => undefined)
    }
  } catch (error) {
    if (!isAlreadyExists(error)) throw error
  }

  let owner: { worktree?: unknown; rootSessionID?: unknown }
  try {
    owner = JSON.parse(await readFile(lockPath, "utf8"))
  } catch {
    throw new Error(
      `[worktree-guard] 所有者情報を読み取れません: ${lockPath}。` +
        `確認後、不要な場合のみこのロックファイルを削除してください。`,
    )
  }

  if (owner.worktree !== worktree || typeof owner.rootSessionID !== "string") {
    throw new Error(
      `[worktree-guard] worktree所有者情報が一致しません: ${lockPath}。` +
        `確認後、不要な場合のみこのロックファイルを削除してください。`,
    )
  }
  if (owner.rootSessionID !== rootSessionID) {
    throw new WorktreeOwnedByAnotherSessionError(owner.rootSessionID)
  }
}

export const WorktreeGuard: Plugin = async ({ directory, client, $ }) => {
  return {
    "tool.execute.before": async (input, output) => {
      const mutatesFiles =
        FILE_EDIT_TOOLS.has(input.tool) ||
        (input.tool === "bash" && isMutatingBash(output.args.command))

      if (!mutatesFiles) return

      // Resolve the session's root so child-agent sessions share their parent task's
      // worktree ownership, while unrelated sessions cannot silently reuse it.
      let currentSessionID = input.sessionID
      let rootSessionID = currentSessionID
      let sessionDirectory = directory
      const seen = new Set<string>()

      for (let depth = 0; depth < 64; depth++) {
        if (seen.has(currentSessionID)) {
          throw new Error(
            "[worktree-guard] セッションの親子関係に循環があります。編集をブロックしました。",
          )
        }
        seen.add(currentSessionID)

        const result = await client.session.get({
          path: { id: currentSessionID },
          query: { directory },
        })
        const session = result.data
        if (!session) {
          throw new Error(
            `[worktree-guard] セッション ${currentSessionID} を確認できません。安全のため編集をブロックしました。`,
          )
        }
        if (depth === 0) sessionDirectory = session.directory
        if (!session.parentID) {
          rootSessionID = session.id
          break
        }
        rootSessionID = session.parentID
        currentSessionID = session.parentID

        if (depth === 63) {
          throw new Error(
            "[worktree-guard] セッションの親子関係が深すぎます。編集をブロックしました。",
          )
        }
      }

      const gitOutput = async (
        command: "--show-toplevel" | "--absolute-git-dir" | "--abbrev-ref HEAD",
      ) =>
        (
          await $`git rev-parse ${command}`
            .cwd(sessionDirectory)
            .quiet()
            .nothrow()
            .text()
        ).trim()

      const [worktree, gitDirectory, branch] = await Promise.all([
        gitOutput("--show-toplevel"),
        gitOutput("--absolute-git-dir"),
        gitOutput("--abbrev-ref HEAD"),
      ])

      // Preserve the previous behavior for non-Git directories.
      if (!worktree || !gitDirectory) return
      if (!branch) {
        throw new Error(
          "[worktree-guard] 現在のブランチを確認できません。安全のため編集をブロックしました。",
        )
      }

      if (PROTECTED_BRANCHES.has(branch)) {
        throw new Error(
          `[worktree-guard] ${branch} 上での編集はブロックされました。` +
            `専用worktreeを作成してから作業してください:\n` +
            `  git worktree add .git/wt/<type>/<name> -b <type>/<name>\n` +
            `(例: git worktree add .git/wt/feat/foo -b feat/foo)`,
        )
      }

      await claimWorktree(gitDirectory, worktree, rootSessionID)
    },
  }
}
