# Hosts

Detailed notes for each machine in this flake. See the root [README](../../README.md) for the overview.

| Host | OS | Arch | Flake entry | Config | Home Manager |
|------|----|------|-------------|--------|--------------|
| [`saffron`](./saffron.md) | NixOS | x86_64-linux | `flake/hosts/saffron.nix` | `hosts/saffron/` | `home/saffron.nix` |
| `saffron-ci` | NixOS | x86_64-linux | same as `saffron` (`isCI = true`) | same | same |
| [`surface`](./surface.md) | NixOS | x86_64-linux | `flake/hosts/surface.nix` | `hosts/surface/` | `home/surface.nix` |
| [`wsl`](./wsl.md) | NixOS (WSL) | x86_64-linux | `flake/hosts/wsl.nix` | `hosts/wsl/` | `home/wsl.nix` |
| [`freesia`](./freesia.md) | nix-darwin | aarch64-darwin | `flake/hosts/freesia.nix` | `hosts/freesia/` | `home/freesia.nix` |
| [`zephyr`](./zephyr.md) | nix-darwin | aarch64-darwin | `flake/hosts/zephyr.nix` | `hosts/zephyr/` | `home/zephyr.nix` |
| [`first-linux`](./first-linux.md) | NixOS (bootstrap) | x86_64-linux | `flake/hosts/first-linux/` | `hosts/first-linux/` | `home/saffron.nix` |
| [`first-darwin`](./first-darwin.md) | nix-darwin (bootstrap) | aarch64-darwin | `flake/hosts/first-darwin/` | `hosts/first-darwin/` | `home/freesia.nix` |

## Rebuild

```bash
nh os switch -H saffron .        # NixOS
nh darwin switch -H freesia .    # nix-darwin
```

CI reference targets: `.#nixosConfigurations.saffron-ci.config.system.build.toplevel` and `.#darwinConfigurations.freesia.config.system.build.toplevel`.
