# `first-darwin`

Bootstrap profile — nix-darwin on `aarch64-darwin`, based on [`freesia`](./freesia.md) but
without sops-nix, so it can be built/activated on a fresh Mac before the host's age key is
registered in `.sops.yaml`.

- **Flake entry**: `flake/hosts/first-darwin/` → `darwinConfigurations.first-darwin`
- **nix-darwin config**: imports `flake/hosts/freesia/configuration.nix`
- **Home Manager**: `home/freesia.nix`, user `crocus`

## What is excluded (vs `freesia`)

- `modules/sops` + `sops-nix.darwinModules.sops`
- `modules/cachix` (imported by `freesia`'s entrypoint, not by `first-darwin`)

Homebrew (`nix-homebrew` + `brew.nix`), the `pkgs/` overlays, and the full `home/freesia.nix`
are kept.

## Rebuild

```bash
nh darwin switch -H first-darwin .
```
