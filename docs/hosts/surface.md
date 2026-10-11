# `surface`

Surface device — NixOS on `x86_64-linux`. Sway-based, lighter than `saffron`.

- **Flake entry**: `flake/hosts/surface.nix` → `nixosConfigurations.surface`
- **NixOS config**: `hosts/surface/` (`configuration.nix`, `hardware-configuration.nix`)
- **Home Manager**: `home/surface.nix`, user `crocus`

## Modules

`flake/hosts/surface.nix` imports:

- `hosts/surface/`
- `xremap-flake.nixosModules.default`, `modules/xremap` (custom keyboard layout — see [xremap](../xremap.md))
- `nix-ld.nixosModules.nix-ld`

`hosts/surface/configuration.nix` imports the shared root `configuration.nix` (which pulls in `modules/`, `modules/fontconfig.nix`, `modules/xremap`, `modules/cachix`, `modules/container.nix`).

Note: unlike `saffron`, this host does **not** import `modules/wm`, `modules/game`, `modules/mount`, or `modules/sops`, and has no custom `pkgs/` overlays.

## Host-specific settings (`hosts/surface/configuration.nix`)

- `networking.hostName = "coccineus"` (the flake attr is `surface`)
- Static IPv4 `192.168.0.18/24` on `enp0s20f0u1u1u4`
- `programs.dconf.enable`, `hardware.graphics.enable`, `services.tailscale.enable`

## Home Manager

`home/surface.nix` imports a CLI/GUI mix: `nixvim`, `opencode`, `emacs`, `nushell`, `yazi`, `gh` (CLI); `obs`, `ghostty`, `obsidian`, `falkon`, `vlc`, `zed-editor`, `nautilus` (GUI); and a **sway** WM stack (`sway`, `waybar`, `swayidle`, `swaylock`, `swaybg`, `swayr`, `fuzzel`, `mako`). Desktop utilities include `pipewire`/`wireplumber`, `grim`/`slurp`, `xremap`, `pavucontrol`.

## Rebuild

```bash
nh os switch -H surface .
```
