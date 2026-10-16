---
description: Stage, commit, push, and open a pull request from the current worktree
agent: build
---

Automate the current worktree's changes all the way to an opened pull request.
Additional hints from the user (optional): $ARGUMENTS

Follow these steps in order. Stop and report if a step is impossible.

1. Inspect state. Run these and read the results before doing anything:
   - `git rev-parse --abbrev-ref HEAD`
   - `git status --short`
   - `git diff`
   - `git diff --cached`
   - `git log --oneline -10`

2. Guard the branch. If the branch is `main` or `master`, stop and tell the user
   to work in a worktree instead. Never commit or push to a protected branch.

3. Stage the intended changes with `git add <paths>`. Stage specific files; never
   use `git add -A` blindly. Never stage secrets, `.env` files, or `flake.lock`
   (the latter is updated automatically).

4. Write the commit message following the repository commit convention:
   `<type>(<scope>): <description>`. English, imperative mood, lowercase first
   letter, no trailing period. Pick the scope from the changed paths (e.g.
   `opencode`, `nix`, `home`, `modules`, host names). Then commit with:
   `git commit -m "<message>"`.

5. If the branch has no commits ahead of the base and the working tree is clean,
   tell the user there is nothing to open a PR for and stop.

6. Push the branch, setting upstream if needed:
   `git push -u origin HEAD`

7. Open the pull request against the default branch:
   `gh pr create --base main --head "$(git branch --show-current)" --title "<conventional title>" --body "<body>"`
   - The title MUST follow the same Conventional Commits convention as the commit
     subject (this repo squash-merges, so the PR title becomes the commit subject).
   - The body should summarize what changed, why, and note any verification done.

8. Print the resulting PR URL.

Do not amend or rebase published commits. Do not force-push.
