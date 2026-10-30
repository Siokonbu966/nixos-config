# Task-scoped worktree policy

For Git repositories, keep each independent task on its own branch and worktree.

- Before making changes, inspect the current branch and working-tree status. Do not assume the current branch is appropriate just because it is not `main` or `master`.
- Continue using the current worktree for follow-ups to the same objective. Read-only questions do not need a new worktree.
- For an unrelated objective, create a new worktree and branch before editing, even when the current branch is already a feature branch. Do not switch branches or repurpose the current checkout.
- Base the new branch on the repository's default branch unless the task explicitly depends on unmerged work or the user specifies another base.
- Follow the repository's worktree location and branch-naming conventions. When working from a linked worktree, resolve the common Git directory with `git rev-parse --path-format=absolute --git-common-dir`; `.git` may be a file rather than a directory.
- Check for an existing worktree or branch name before creating one. Use a descriptive branch name appropriate to the change (for example, `feat/<name>`, `fix/<name>`, or `docs/<name>`).
- Create worktrees with the native `worktree_create` capability when available, then immediately associate this OpenCode session with the returned directory using `session_move`. Do not use `git worktree add` followed by manual copying, and do not make edits in the old worktree after moving.
- Never move or copy uncommitted changes into a new worktree implicitly. If the task depends on those changes, or task separation is ambiguous, ask the user before proceeding.
- If a new worktree cannot be created or the session cannot be moved, stop before editing and explain the blocker rather than silently continuing in the existing checkout.
