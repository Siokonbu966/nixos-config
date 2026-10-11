# `wsl`

WSL environment — NixOS (via NixOS-WSL) on `x86_64-linux`. Minimal, CLI-only.

- **Flake entry**: `flake/hosts/wsl.nix` → `nixosConfigurations.wsl`
- **NixOS config**: `hosts/wsl/` (`configuration.nix`)
- **Home Manager**: `home/wsl.nix`, user `crocus`

## Modules

`flake/hosts/wsl.nix` imports:

- `nixos-wsl.nixosModules.default` with `wsl.enable = true`, `wsl.defaultUser = "crocus"`
- `nix-ld.nixosModules.nix-ld`
- `hosts/wsl/`
- `modules/font.nix`, `modules/fontconfig.nix`, `modules/i18n.nix`

Unlike the other NixOS hosts, it does **not** import the shared root `configuration.nix`, has no `modules/wm`, no sops, and no xremap.

## Overlays / custom packages

- Custom package from `pkgs/`: `ink`

## Host-specific settings (`hosts/wsl/configuration.nix`)

- User `crocus` in `wheel`, shell `zsh`, `programs.zsh.enable`
- `nixpkgs.config.allowUnfree = true`
- System packages: `git`, `vim`, `firefox`
- `nix.settings.experimental-features = [ "nix-command" "flakes" ]`

## Home Manager

`home/wsl.nix` is CLI-only: `nixvim`, `opencode`, `emacs`, `nushell`, `yazi`, `gh`, `git`, `direnv`, `tmux`, `zsh`, plus `ink` and `nb`. No GUI or WM modules.

## Rebuild

```bash
nh os switch -H wsl .
```
