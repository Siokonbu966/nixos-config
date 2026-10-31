#!/usr/bin/env bash
set -euo pipefail

cd "$(git rev-parse --show-toplevel)"

latest_version=$(
  gh api --paginate 'repos/block/buzz/releases?per_page=100' \
    --jq '.[] | select(.prerelease == false) | .tag_name' \
    | sed -n 's/^desktop-v//p' \
    | grep -E '^[0-9]+(\.[0-9]+)*$' \
    | sort -V \
    | tail -n1
)
current_version=$(sed -n 's/^  version = "\([^"]*\)";$/\1/p' pkgs/buzz-desktop.nix)
sidecars_version=$(sed -n 's/^  version = "\([^"]*\)";$/\1/p' pkgs/buzz-sidecars.nix)

if [ -z "$latest_version" ] || [ -z "$current_version" ]; then
  echo "Could not determine the latest or current Buzz desktop version" >&2
  exit 1
fi

if [ "$current_version" != "$sidecars_version" ]; then
  echo "buzz-desktop and buzz-sidecars versions do not match" >&2
  exit 1
fi

if [ "$current_version" = "$latest_version" ]; then
  echo "Buzz desktop packages are already at the latest stable version ($current_version)"
  exit 0
fi

newest_version=$(printf '%s\n' "$current_version" "$latest_version" | sort -V | tail -n1)
if [ "$newest_version" != "$latest_version" ]; then
  echo "Refusing to downgrade Buzz from $current_version to $latest_version"
  exit 0
fi

nix-update --file pkgs/update-targets.nix --override-filename pkgs/buzz-desktop.nix \
  --version "$latest_version" buzz-desktop
nix-update --file pkgs/update-targets.nix --override-filename pkgs/buzz-sidecars.nix \
  --version "$latest_version" buzz-sidecars
