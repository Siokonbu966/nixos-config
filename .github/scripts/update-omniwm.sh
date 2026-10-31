#!/usr/bin/env bash
set -euo pipefail

cd "$(git rev-parse --show-toplevel)"

latest_version=$(
  gh api --paginate 'repos/OmniNull/OmniWM/releases?per_page=100' \
    --jq '.[] | select(.prerelease == false) | .tag_name' \
    | sed -n 's/^v//p' \
    | grep -E '^[0-9]+(\.[0-9]+)*$' \
    | sort -V \
    | tail -n1
)
current_version=$(sed -n 's/^  version = "\([^"]*\)";$/\1/p' pkgs/omniwm.nix)

if [ -z "$latest_version" ] || [ -z "$current_version" ]; then
  echo "Could not determine the latest or current OmniWM version" >&2
  exit 1
fi

if [ "$current_version" = "$latest_version" ]; then
  echo "OmniWM is already at the latest stable version ($current_version)"
  exit 0
fi

newest_version=$(printf '%s\n' "$current_version" "$latest_version" | sort -V | tail -n1)
if [ "$newest_version" != "$latest_version" ]; then
  echo "Refusing to downgrade OmniWM from $current_version to $latest_version"
  exit 0
fi

nix-update --file pkgs/update-targets.nix --override-filename pkgs/omniwm.nix \
  --version "$latest_version" --src-only omniwm
