import { describe, expect, test } from "bun:test"
import { validateCommitMessage } from "./commit-message"

describe("commit message convention", () => {
  test.each([
    "feat(opencode): add commit message lint",
    "fix: handle empty diff",
    "build(nix): update flake inputs",
    "docs: update usage guide",
    "chore(home): tidy configuration",
    "ci: run commit message tests",
    "refactor(git): extract validation",
    "test(opencode): cover invalid messages",
    "perf: reduce startup time",
    "style: format source files",
    "revert(git): restore previous hook behavior",
  ])("accepts valid message: %s", (message) => {
    expect(validateCommitMessage(message)).toBeNull()
  })

  test.each([
    "update files",
    "feature(opencode): add lint",
    "feat(): add lint",
    "feat(opencode): Add lint",
    "feat(opencode): add lint.",
    "feat(opencode): add lint\nextra explanation",
    "feat(opencode): ",
    " feat(opencode): add lint",
    "feat(opencode): add lint ",
    "feat( opencode): add lint",
  ])("rejects invalid message: %s", (message) => {
    expect(validateCommitMessage(message)).not.toBeNull()
  })
})
