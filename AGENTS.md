# AGENTS.md

Nix Flake monorepo: NixOS + nix-darwin + Home Manager. No single "source" file — config is split across flake entrypoints, per-host dirs, and HM modules.

## Hosts

| Host | OS | Entrypoints |
|------|----|-------------|
| `saffron` | NixOS (primary desktop, x86_64) | `flake/hosts/saffron.nix`, `hosts/saffron/`, `home/saffron.nix` |
| `saffron-ci` | NixOS (CI variant, `isCI = true`) | same as saffron, minus nvidia/secureboot/vmware |
| `surface` | NixOS (x86_64) | `flake/hosts/surface.nix`, `hosts/surface/`, `home/surface.nix` |
| `wsl` | NixOS (WSL) | `flake/hosts/wsl.nix`, `hosts/wsl/`, `home/wsl.nix` |
| `freesia` | nix-darwin (aarch64) | `flake/hosts/freesia.nix`, `hosts/freesia/`, `home/freesia.nix` |
| `zephyr` | nix-darwin (aarch64) | `flake/hosts/zephyr.nix`, `hosts/zephyr/`, `home/zephyr.nix` |

- `README.md` is out of date: it lists `desktop` and `home/default.nix`, which do not exist. Trust the flake and filesystem.
- Root `configuration.nix` is the shared NixOS config, imported by `hosts/saffron/configuration.nix` and `hosts/surface/configuration.nix`.
- `modules/` = shared NixOS modules (`sops/`, `wm/` for niri/sway/noctalia, `xremap/`, `network/`, etc.), selectively imported per-entrypoint.
- `pkgs/` = custom packages, exposed via `nixpkgs.overlays` in each `flake/hosts/*.nix` (overlay set differs per host — e.g. `buzz-*` only on saffron).
- Nixvim is a flake input evaluated through `nixvim-module = nixvim.homeModules.nixvim` (extraSpecialArgs). It has its own `flake.nix` but is NOT built standalone; edit `home/programs/nixvim/`.

## Developer Workflows

```bash
# Rebuild (preferred)
nh os switch -H <host> .        # NixOS
nh darwin switch -H <host> .    # nix-darwin
nh os switch -n                 # dry-run

# Fallbacks
sudo nixos-rebuild switch --flake .#<host>
darwin-rebuild switch --flake .#<host>

# Verify flake evaluates (run before declaring a Nix change done)
nix eval '.#nixosConfigurations.<host>.config.system.build.toplevel.drvPath'
nix eval '.#darwinConfigurations.<host>.config.system.build.toplevel.drvPath'
```

## Git & Worktree Rules (important)

- **`main`/`master` are protected.** The plugin `home/programs/opencode/worktree-guard.ts` throws on `edit`/`write` there. Work only inside a worktree:
  `git worktree add .git/wt/<type>/<name> -b <type>/<name>` (this worktree: `.git/wt/feat/opencode_config`).
- Commit messages: **English only** (enforced by `home/programs/opencode/AGENTS.md`). Use Conventional Commits as in history: `feat(opencode): ...`, `fix(sops): ...`, `chore(nix): ...`, `refactor(git): ...`.
- **`git add` every new file before building/evaluating.** Flakes ignore untracked files, so the evaluator won't see them.
- Flake input updates are automated daily (`.github/workflows/update-flake.yml`, min release age 3 days, auto-merge). Don't hand-edit `flake.lock`.

## Gotchas

- OpenCode config is **generated from `home/programs/opencode/default.nix` into `xdg.configFile`** — there is no checked-in `opencode.json`. Edit the Nix file to change permissions/plugins/skills/providers/agents.
- `my-dotfiles` is a non-flake input (`flake = false`), passed via `extraSpecialArgs`; raw dotfiles live in `configs/` or `home/programs/utils/dotfiles.nix` mapping.
- Secrets use sops-nix: age keys per host in `.sops.yaml`, encrypted files in `secrets/`. No plaintext secrets in the repo.
- Home Manager is embedded as a NixOS/darwin module (`useGlobalPkgs = true`). **Never run standalone `home-manager switch`.**
- Niri config is raw KDL at `configs/niri/config.kdl`; validate with `niri validate -c configs/niri/config.kdl`.
- CI (`.github/workflows/actions.yml`) builds `.#nixosConfigurations.saffron-ci...toplevel` and `.#darwinConfigurations.freesia...toplevel` — use these as the reference build targets.
