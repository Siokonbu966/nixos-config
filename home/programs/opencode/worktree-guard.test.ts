import { afterEach, describe, expect, test } from "bun:test"
import { mkdtemp, readFile, rm } from "node:fs/promises"
import os from "node:os"
import path from "node:path"
import {
  claimWorktree,
  isMutatingBash,
  WorktreeOwnedByAnotherSessionError,
} from "./worktree-guard"

const temporaryDirectories: string[] = []

afterEach(async () => {
  await Promise.all(
    temporaryDirectories
      .splice(0)
      .map((directory) => rm(directory, { recursive: true, force: true })),
  )
})

async function temporaryDirectory() {
  const directory = await mkdtemp(
    path.join(os.tmpdir(), "worktree-guard-test-"),
  )
  temporaryDirectories.push(directory)
  return directory
}

describe("worktree guard", () => {
  test("identifies file-mutating bash commands", () => {
    expect(isMutatingBash("git commit -m 'change'")).toBe(true)
    expect(isMutatingBash("sed -i 's/a/b/' file.txt")).toBe(true)
    expect(isMutatingBash("git status --short")).toBe(false)
  })

  test("allows the same root session to reuse its worktree", async () => {
    const gitDirectory = await temporaryDirectory()
    await claimWorktree(gitDirectory, "/repo/task-a", "session-a")

    await expect(
      claimWorktree(gitDirectory, "/repo/task-a", "session-a"),
    ).resolves.toBeUndefined()
  })

  test("blocks a different root session from reusing the worktree", async () => {
    const gitDirectory = await temporaryDirectory()
    await claimWorktree(gitDirectory, "/repo/task-a", "session-a")

    await expect(
      claimWorktree(gitDirectory, "/repo/task-a", "session-b"),
    ).rejects.toBeInstanceOf(WorktreeOwnedByAnotherSessionError)
  })

  test("allows only one session to claim a worktree concurrently", async () => {
    const gitDirectory = await temporaryDirectory()
    const results = await Promise.allSettled([
      claimWorktree(gitDirectory, "/repo/task-a", "session-a"),
      claimWorktree(gitDirectory, "/repo/task-a", "session-b"),
    ])

    expect(
      results.filter((result) => result.status === "fulfilled"),
    ).toHaveLength(1)
    expect(
      results.filter((result) => result.status === "rejected"),
    ).toHaveLength(1)
  })

  test("creates a private ownership record", async () => {
    const gitDirectory = await temporaryDirectory()
    await claimWorktree(gitDirectory, "/repo/task-a", "session-a")

    const record = JSON.parse(
      await readFile(
        path.join(gitDirectory, "opencode-worktree-guard", "owner.json"),
        "utf8",
      ),
    )
    expect(record).toEqual({
      worktree: "/repo/task-a",
      rootSessionID: "session-a",
    })
  })
})
