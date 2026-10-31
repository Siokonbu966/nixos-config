#!/usr/bin/env bash
set -euo pipefail

cd "$(git rev-parse --show-toplevel)"

metadata=$(curl --fail --silent --show-error https://registry.npmjs.org/rea-agents/latest)
latest_version=$(jq --exit-status --raw-output '.version' <<<"$metadata")
tarball_url=$(jq --exit-status --raw-output '.dist.tarball' <<<"$metadata")
current_version=$(sed -n 's/^  version = "\([^"]*\)";$/\1/p' pkgs/rea.nix)

if [ -z "$current_version" ]; then
  echo "Could not read the current rea version from pkgs/rea.nix" >&2
  exit 1
fi

if [ "$current_version" = "$latest_version" ]; then
  echo "rea is already at the latest npm version ($current_version)"
  exit 0
fi

newest_version=$(printf '%s\n' "$current_version" "$latest_version" | sort -V | tail -n1)
if [ "$newest_version" != "$latest_version" ]; then
  echo "Refusing to downgrade rea from $current_version to $latest_version"
  exit 0
fi

lockfile_url="https://raw.githubusercontent.com/morluto/rea/rea-agents-${latest_version}/package-lock.json"
tarball_hash=$(nix-prefetch-url --type sha256 "$tarball_url")
lockfile_hash=$(nix-prefetch-url --type sha256 "$lockfile_url")
tarball_hash=$(nix hash convert --hash-algo sha256 --to sri "$tarball_hash")
lockfile_hash=$(nix hash convert --hash-algo sha256 --to sri "$lockfile_hash")

python3 - "$latest_version" "$tarball_hash" "$lockfile_hash" <<'PY'
from pathlib import Path
import re
import sys

version, tarball_hash, lockfile_hash = sys.argv[1:]
path = Path("pkgs/rea.nix")
contents = path.read_text()

contents, version_count = re.subn(
    r'(?m)^(  version = ")[^"]+(";)$',
    rf'\g<1>{version}\g<2>',
    contents,
    count=1,
)
if version_count != 1:
    raise SystemExit("Could not update the rea version declaration")

for name, new_hash in (("tarball", tarball_hash), ("lockfile", lockfile_hash)):
    pattern = re.compile(
        rf'({name} = fetchurl \{{.*?\bhash = ")[^"]+(";)', re.DOTALL
    )
    contents, count = pattern.subn(rf'\g<1>{new_hash}\g<2>', contents, count=1)
    if count != 1:
        raise SystemExit(f"Could not update the rea {name} hash")

path.write_text(contents)
PY

echo "Updated rea to $latest_version; npm dependency hash will be refreshed separately"
