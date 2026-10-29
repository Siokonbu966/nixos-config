import { link, mkdir, open, readFile, unlink } from "node:fs/promises"
import { randomUUID } from "node:crypto"
import path from "node:path"

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
