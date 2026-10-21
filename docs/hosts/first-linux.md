# `first-linux`

Bootstrap profile — NixOS on `x86_64-linux`, based on [`saffron`](./saffron.md) but with the
pieces that cannot be built/activated on a fresh machine removed (sops secrets and
secret-dependent modules, Secure Boot keys, etc.). Use it to get a first working system,
then switch to `saffron` once the host's age key is registered in `.sops.yaml`.

- **Flake entry**: `flake/hosts/first-linux/` → `nixosConfigurations.first-linux`
- **NixOS config**: `flake/hosts/first-linux/` (`default.nix`, `configuration.nix`)
- **Hardware**: reuses `flake/hosts/saffron/hardware-configuration.nix` (same machine)
- **Home Manager**: `home/saffron.nix`, user `crocus`

## What is excluded (vs `saffron`)

| Feature | `saffron` | `first-linux` |
|---------|-----------|---------------|
| sops-nix + `modules/sops` (age key, netrc) | yes | no |
| `modules/mount` (CIFS + `samba_credentials`) | yes | no |
| `modules/cachix` | yes | no |
| `xremap` (`modules/xremap` + flake module) | yes | no |
| Secure Boot / lanzaboote (`modules/secureboot.nix`) | yes | no |
| `repro2` sender service | yes | no |
| Static IP (`enp10s0`) | yes | no |
| VMware host + `vmware` video driver | yes | no |
| NVIDIA drivers (`nvidia/`) | yes | yes |

`programs.nix-ld`, the `xwayland-satellite`/`buzz-*` overlays, `modules/wm`, `modules/game`,
`modules/vr`, `services.tailscale`, and the full `home/saffron.nix` are kept.

## How the exclusions work

`modules/xremap` and `modules/cachix` are imported by the host entrypoints
(`saffron`/`surface`/`freesia`), not by the shared root `configuration.nix`, so
`first-linux` simply does not import them. Its `default.nix` also omits the sops, xremap
flake module, `repro2` sender, and lanzaboote modules that `saffron` adds.

## Rebuild

```bash
nh os switch -H first-linux .
```
