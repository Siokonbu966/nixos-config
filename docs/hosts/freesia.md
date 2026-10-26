# `freesia`

macOS laptop — nix-darwin on `aarch64-darwin`. Full-featured, includes Homebrew and sops-nix.

- **Flake entry**: `flake/hosts/freesia.nix` → `darwinConfigurations.freesia`
- **nix-darwin config**: `hosts/freesia/` (`default.nix`, `brew.nix`)
- **Home Manager**: `home/freesia.nix`, user `crocus`
- **CI target**: `.#darwinConfigurations.freesia.config.system.build.toplevel`

## Modules

`flake/hosts/freesia.nix` imports:

- `hosts/freesia/` (imports `./brew.nix`, `modules/font.nix`, `modules/cachix`)
- `home-manager.darwinModules.home-manager`
- `modules/sops` + `sops-nix.darwinModules.sops`
- `nix-homebrew.darwinModules.nix-homebrew`

## Overlays / custom packages

- Custom packages from `pkgs/`: `ink`, `effectcraft`, `souieba`
- `protobuf` is overridden with `doCheck = false`

## Host-specific settings (`hosts/freesia/default.nix`)

- `nixpkgs.hostPlatform = "aarch64-darwin"`, `system.primaryUser = "crocus"`, `allowUnfree = true`
- `system.stateVersion = 6`; `system.configurationRevision` set from the flake revision
- Touch ID for sudo: `security.pam.services.sudo_local = { touchIdAuth = true; reattach = true; }`
- User `crocus`, home `/Users/crocus`
- System package `vim`

## Homebrew (`hosts/freesia/brew.nix` + `nix-homebrew`)

`nix-homebrew` manages immutable taps (`homebrew-core`, `homebrew-cask`, `homebrew-bundle`, `autoMigrate = true`, `mutableTaps = false`). Casks: `firefox`, `ghostty`, `karabiner-elements`, `discord`, `slack`, `google-chrome`, `lm-studio`, `tailscale-app`, `appcleaner`, `whatcable`, `anki`, `obs`. `onActivation.autoUpdate = false`.

## Secrets (sops-nix)

Age key for this host is registered in `.sops.yaml`. `modules/sops` manages `samba_credentials`, `cachix_auth_token`, `github_token`, and the `nix-netrc` template.

## Home Manager

`home/freesia.nix` imports CLI tools (`nixvim`, `opencode`, `emacs`, `nushell`, `yazi`, `gh`, `git`, `direnv`, `tmux`, `zsh`), containers (`docker`, `colima`), GUI (`ghostty`, `vesktop`), and apps (`ink`, `effectcraft`, `nb`, `late-sh`, `souieba`, `R`).

## Rebuild

```bash
nh darwin switch -H freesia .
```
