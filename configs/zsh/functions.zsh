#!/usr/bin/env zsh

# g: 引数なし→ghq+fzfでリポジトリ選択してcd、引数あり→gitに転送
function __ghq_pick() {
  local ghq_root selected
  ghq_root="$(ghq root)"

  selected="$(
    ghq list --full-path \
      | sed "s#^${ghq_root}/##" \
      | fzf --height 40% --reverse \
          --preview "eza --tree --level=2 --git-ignore --color=always --icons \"${ghq_root}/{}\" 2>/dev/null || ls \"${ghq_root}/{}\"" \
  )"

  [[ -n "$selected" ]] && printf '%s\n' "${ghq_root}/${selected}"
}

function g() {
  if [[ $# -eq 0 ]]; then
    local selected
    selected="$(__ghq_pick)" || return
    [[ -n "$selected" ]] && cd -- "$selected"
  else
    git "$@"
  fi
}

# worktree: git worktreeをfzfで選択して移動
function worktree() {
  local selected
  selected="$(
    git wt --json \
      | jq -r '.[] | [
          (if .current then "*" else " " end),
          .branch,
          .path,
          .head
        ] | @tsv' \
      | fzf --height 40% --reverse \
          --with-nth=1,2 \
          --delimiter=$'\t' \
          --preview 'git -C {3} log --oneline --graph -20' \
      | cut -f3
  )"

  [[ -n "$selected" ]] && cd -- "$selected"
}
