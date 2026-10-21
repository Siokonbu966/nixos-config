# nixos-config

A Nix Flake monorepo for NixOS, nix-darwin, and Home Manager.

[日本語版はこちら (Japanese)](./docs/README.ja.md)

## Hosts

| Host | OS | Purpose | Entrypoints |
|------|----|---------|-------------|
| `saffron` | NixOS (x86_64) | Primary desktop | `flake/hosts/saffron.nix`, `hosts/saffron/`, `home/saffron.nix` |
| `saffron-ci` | NixOS (x86_64) | CI variant (`isCI = true`); no nvidia/secureboot/vmware | same as saffron |
| `surface` | NixOS (x86_64) | Surface device | `flake/hosts/surface.nix`, `hosts/surface/`, `home/surface.nix` |
| `wsl` | NixOS (WSL) | WSL environment | `flake/hosts/wsl.nix`, `hosts/wsl/`, `home/wsl.nix` |
| `freesia` | nix-darwin (aarch64) | macOS | `flake/hosts/freesia.nix`, `hosts/freesia/`, `home/freesia.nix` |
| `zephyr` | nix-darwin (aarch64) | macOS | `flake/hosts/zephyr.nix`, `hosts/zephyr/`, `home/zephyr.nix` |

See [`docs/hosts/`](./docs/hosts/README.md) for per-host details.

## Directory structure

```
.
├── flake.nix               # Flake entrypoint (inputs + outputs)
├── flake/hosts/            # Per-host flake definitions (saffron, surface, wsl, freesia, zephyr)
├── configuration.nix       # Shared NixOS config (imported by saffron/surface)
├── hosts/                  # Per-host configuration
│   ├── saffron/
│   ├── surface/
│   ├── wsl/
│   ├── freesia/
│   └── zephyr/
├── modules/                # Shared NixOS modules
│   ├── boot.nix
│   ├── font.nix
│   ├── i18n.nix
│   ├── network/            # Network / wifi
│   ├── sops/               # sops-nix secrets
│   ├── secureboot.nix
│   ├── wm/                 # Window managers (niri, sway, noctalia)
│   └── xremap/
├── home/                   # Home Manager configuration
│   ├── saffron.nix         # HM entry per host
│   ├── surface.nix
│   ├── wsl.nix
│   ├── freesia.nix
│   ├── zephyr.nix
│   ├── programs/           # Per-program HM modules
│   └── tools/
├── pkgs/                   # Custom packages (exposed via overlays)
├── nvidia/                 # NVIDIA configuration
├── configs/                # Raw dotfiles / configs
└── secrets/                # sops-encrypted secrets
```

## Rebuild

```bash
# NixOS (saffron / saffron-ci / surface / wsl) — recommended
nh os switch -H <host> .

# nix-darwin (freesia / zephyr) — recommended
nh darwin switch -H <host> .

# Fallbacks
sudo nixos-rebuild switch --flake .#<host>
darwin-rebuild switch --flake .#<host>

# Dry run (test)
nh os switch -H <host> . -n
nh darwin switch -H <host> . -n
```

Verify a flake evaluates (run before declaring a Nix change done):

```bash
nix eval '.#nixosConfigurations.<host>.config.system.build.toplevel.drvPath'
nix eval '.#darwinConfigurations.<host>.config.system.build.toplevel.drvPath'
```

CI builds `.#nixosConfigurations.saffron-ci...toplevel` and `.#darwinConfigurations.freesia...toplevel` as the reference targets.

## Documentation

- [Per-host notes](./docs/hosts/README.md)
- [xremap](docs/xremap.md) — custom keyboard layout and layers
- [日本語版 README](./docs/README.ja.md)

## Notes

- Home Manager is embedded as a NixOS/darwin module (`useGlobalPkgs = true`). Never run standalone `home-manager switch`.
- Secrets use sops-nix: per-host age keys in `.sops.yaml`, encrypted files in `secrets/`. No plaintext secrets in the repo.
- Custom packages in `pkgs/` are exposed via `nixpkgs.overlays` in each `flake/hosts/*.nix` (the overlay set differs per host).
- Nixvim is evaluated through `nixvim.homeModules.nixvim`; edit `home/programs/nixvim/`.
- OpenCode config is generated from `home/programs/opencode/default.nix` into `xdg.configFile` — edit the Nix file, not a generated JSON.
- Flake inputs are updated automatically (`.github/workflows/update-flake.yml`). Don't hand-edit `flake.lock`.
