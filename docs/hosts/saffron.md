# `saffron` (and `saffron-ci`)

Primary desktop — NixOS on `x86_64-linux`. This is the most feature-complete host.

- **Flake entry**: `flake/hosts/saffron.nix` → `nixosConfigurations.saffron` / `nixosConfigurations.saffron-ci`
- **NixOS config**: `hosts/saffron/` (`configuration.nix`, `hardware-configuration.nix`)
- **Home Manager**: `home/saffron.nix`, user `crocus`

## `saffron` vs `saffron-ci`

`saffron-ci` is the same system with `specialArgs.isCI = true`, defined in `flake.nix`. It strips hardware-specific and boot-critical pieces so it can build in CI:

| Feature | `saffron` | `saffron-ci` |
|---------|-----------|--------------|
| NVIDIA drivers (`nvidia/`) | yes | no |
| Secure Boot / lanzaboote (`modules/secureboot.nix`) | yes | no |
| VMware host + video driver | yes | no |

CI builds `.#nixosConfigurations.saffron-ci.config.system.build.toplevel` (see `.github/workflows/actions.yml`).

## Modules

`flake/hosts/saffron.nix` imports:

- `hosts/saffron/` (host config)
- `modules/xremap` (custom keyboard layout — see [xremap](../xremap.md)), `modules/wm` (niri + noctalia, greetd session), `modules/game`, `modules/mount`, `modules/sops`
- `sops-nix.nixosModules.sops`, `xremap-flake.nixosModules.default`, `nix-ld.nixosModules.nix-ld`
- Non-CI only: `nvidia/`, `lanzaboote.nixosModules.lanzaboote`

`hosts/saffron/configuration.nix` also pulls in the shared root `configuration.nix` (which imports `modules/`, `modules/fontconfig.nix`, `modules/xremap`, `modules/cachix`, `modules/container.nix`).

## Overlays / custom packages

- `xwayland-satellite` (upstream overlay)
- Custom packages from `pkgs/`: `buzz-sidecars`, `buzz-desktop`, `ink`, `effectcraft`, `souieba`

## Host-specific settings (`hosts/saffron/configuration.nix`)

- `networking.hostName = "saffron"`; static IPv4 `192.168.0.92/24` on `enp10s0`
- `hardware.brillo.enable`, `hardware.i2c.enable`, `programs.obs-studio.enableVirtualCamera`
- `services.tailscale.enable`
- `boot.kernelModules = [ "v4l2loopback" ]`
- `virtualisation.vmware.host.enable` + `vmware` video driver (non-CI)
- System package `xwayland-satellite`
- CIFS share mounted at `/mnt/share` (`//192.168.0.96/share`, `modules/mount`) using sops-managed `samba_credentials`

## Secrets (sops-nix)

Age key for this host is registered in `.sops.yaml`. `modules/sops` manages `samba_credentials`, `cachix_auth_token`, and `github_token`, and a `nix-netrc` template for `api.github.com`.

## Home Manager

`home/saffron.nix` enables the noctalia HM module and imports ~80 program modules: CLI (`nixvim`, `opencode`, `emacs`, `nushell`, `yazi`, `gh`, …), GUI (`noctalia`, `obs`, `ghostty`, `gimp`, `ollama`, `signal-desktop`, music/video tools), WM (`niri`, `waybar`, `swayidle`/`swaylock`), and desktop-specific utilities (`pipewire`/`wireplumber`, `brightnessctl`, `ddcutil`, `grim`, `xremap`, `playerctl`, …). It also installs `pkgs.buzz-desktop`.

## Rebuild

```bash
nh os switch -H saffron .
nh os switch -H saffron-ci .    # CI variant, usually not needed locally
```
