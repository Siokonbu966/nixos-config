import { Plugin } from "@opencode/plugin"
import { execFile } from "node:child_process"
import { promisify } from "node:util"
import { claimWorktree, isMutatingBash } from "./worktree-guard"

const execFileAsync = promisify(execFile)
// OpenCode v2 calls the command tool `shell` and the multi-file edit tool
// `patch`. Keep the legacy names as well so this plugin remains compatible
// with older clients.
const FILE_EDIT_TOOLS = new Set(["edit", "write", "patch", "apply_patch"])

async function gitOutput(directory: string, argument: string) {
  try {
    const result = await execFileAsync("git", ["rev-parse", argument], {
      cwd: directory,
      encoding: "utf8",
    })
    return result.stdout.trim()
  } catch (error) {
    const stderr =
      typeof error === "object" && error !== null && "stderr" in error
        ? String(error.stderr)
        : ""
    if (stderr.includes("not a git repository")) return ""
    throw new Error(
      `[worktree-guard] git rev-parse ${argument} を実行できません。安全のため編集をブロックしました。`,
      { cause: error },
    )
  }
}

type SessionInfo = {
  id: string
  location: { directory: string }
  parentID?: string
}

export default Plugin.define({
  id: "worktree-guard",
  async setup(ctx) {
    await ctx.tool.hook("execute.before", async (event) => {
      const input = event.input as { command?: unknown } | undefined
      const mutatesFiles =
        FILE_EDIT_TOOLS.has(event.tool) ||
        ((event.tool === "shell" || event.tool === "bash") &&
          typeof input?.command === "string" &&
          isMutatingBash(input.command))

      if (!mutatesFiles) return

      // Resolve the root so child-agent sessions share their parent task's claim.
      let currentSessionID = event.sessionID
      let rootSessionID = currentSessionID
      let sessionDirectory: string | undefined
      const seen = new Set<string>()

      for (let depth = 0; depth < 64; depth++) {
        if (seen.has(currentSessionID)) {
          throw new Error(
            "[worktree-guard] セッションの親子関係に循環があります。編集をブロックしました。",
          )
        }
        seen.add(currentSessionID)

        const session = (await ctx.session.get({
          sessionID: currentSessionID,
        })) as SessionInfo | undefined
        if (!session) {
          throw new Error(
            `[worktree-guard] セッション ${currentSessionID} を確認できません。安全のため編集をブロックしました。`,
          )
        }
        if (depth === 0) sessionDirectory = session.location.directory
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

      if (!sessionDirectory) {
        throw new Error(
          "[worktree-guard] セッションの作業ディレクトリを確認できません。安全のため編集をブロックしました。",
        )
      }

      const [worktree, gitDirectory, branch] = await Promise.all([
        gitOutput(sessionDirectory, "--show-toplevel"),
        gitOutput(sessionDirectory, "--absolute-git-dir"),
        gitOutput(sessionDirectory, "--abbrev-ref HEAD"),
      ])

      // Preserve the previous behavior for non-Git directories.
      if (!worktree || !gitDirectory) return
      if (!branch) {
        throw new Error(
          "[worktree-guard] 現在のブランチを確認できません。安全のため編集をブロックしました。",
        )
      }

      if (branch === "main" || branch === "master") {
        throw new Error(
          `[worktree-guard] ${branch} 上での編集はブロックされました。` +
            `専用worktreeを作成し、セッションを移動してから作業してください。\n` +
            `  worktree_create({ name: "<type>/<name>" })\n` +
            `  session_move({ directory: "<作成されたworktreeのパス>" })`,
        )
      }

      await claimWorktree(gitDirectory, worktree, rootSessionID)
    })
  },
})
