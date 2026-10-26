import type { Plugin } from "@opencode-ai/plugin"

const PROTECTED = ["main", "master"]
const FILE_EDIT_TOOLS = new Set(["edit", "write", "apply_patch"])
const MUTATING_BASH = [
  /\bgit(?:\s+-C\s+\S+)?\s+(?:apply|am|cherry-pick|commit|merge|rebase|reset|restore|revert|checkout|stash)\b/,
  /(?:^|[;&|]\s*)(?:cp|dd|install|ln|mkdir|mv|rm|rmdir|tee|touch|truncate)\b/,
  /\b(?:perl|sed)\b[^;&|]*\s-i(?:\s|$)/,
  /(?:^|[;&|]\s*)[^;&|]*\s>>?\s*\S+/,
]

const isMutatingBash = (command: string) =>
  MUTATING_BASH.some((pattern) => pattern.test(command))

export const WorktreeGuard: Plugin = async ({ directory, $ }) => {
  return {
    "tool.execute.before": async (input, output) => {
      const mutatesFiles =
        FILE_EDIT_TOOLS.has(input.tool) ||
        (input.tool === "bash" && isMutatingBash(output.args.command))

      if (!mutatesFiles) return

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
