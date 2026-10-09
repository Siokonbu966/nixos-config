import type { Plugin } from "@opencode-ai/plugin"

const PROTECTED = ["main", "master"]

export const WorktreeGuard: Plugin = async ({ directory, $ }) => {
  return {
    "tool.execute.before": async (input) => {
      if (input.tool !== "edit" && input.tool !== "write") return

      const branch = (
        await $`git rev-parse --abbrev-ref HEAD`
          .cwd(directory)
          .quiet()
          .nothrow()
          .text()
      ).trim()

      if (!branch || branch === "HEAD") return
      if (!PROTECTED.includes(branch)) return

      throw new Error(
        `[worktree-guard] ${branch} 上での編集はブロックされました。` +
          `専用worktreeを作成してから作業してください:\n` +
          `  git worktree add .git/wt/<type>/<name> -b <type>/<name>\n` +
          `(例: git worktree add .git/wt/feat/foo -b feat/foo)`,
      )
    },
  }
}
