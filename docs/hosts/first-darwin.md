# `first-darwin`

Bootstrap profile — nix-darwin on `aarch64-darwin`, based on [`freesia`](./freesia.md) but
without sops-nix, so it can be built/activated on a fresh Mac before the host's age key is
registered in `.sops.yaml`.

[日本語版はこちら (Japanese)](./first-darwin.ja.md)

- **Flake entry**: `flake/hosts/first-darwin/` → `darwinConfigurations.first-darwin`
- **nix-darwin config**: imports `flake/hosts/freesia/configuration.nix`
- **Home Manager**: `home/freesia.nix`, user `crocus`

## What is excluded (vs `freesia`)

- `modules/sops` + `sops-nix.darwinModules.sops`
- `modules/cachix` (imported by `freesia`'s entrypoint, not by `first-darwin`)

Homebrew (`nix-homebrew` + `brew.nix`), the `pkgs/` overlays, and the full `home/freesia.nix`
are kept.

## Install guide (new to Nix)

`first-darwin` omits sops, so it can be applied on a fresh Mac even without an age key.

> **Two assumptions**
> 1. This config assumes the username `crocus` (home `/Users/crocus`). The username is defined once as the `username` variable in `flake.nix`; every host (including `first-darwin`) receives it via `specialArgs`, so change it there to use another name.
> 2. Run as an **admin** user. Installing Homebrew and the apps (Firefox, ghostty, …) needs the admin password and takes tens of minutes.

### 1. Install Lix (recommended) or Nix
On macOS we recommend [Lix](https://lix.systems/), a community fork of Nix with faster
evaluation and friendlier errors:
```bash
curl -sSf -L https://install.lix.systems/lix | sh -s -- install
```
Plain Nix also works if you prefer the [Determinate Systems installer](https://github.com/DeterminateSystems/nix-installer)
(`curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install`).
Open a **new terminal** and confirm with `nix --version` (it should report Lix).

### 2. Clone the repo
```bash
git clone https://github.com/Siokonbu966/nixos-config ~/nixos-config
cd ~/nixos-config
```
If `git` is missing, install it with `xcode-select --install`.

### 3. First apply
```bash
nix run nix-darwin -- switch --flake ~/nixos-config#first-darwin
```
- You will be asked for the admin password.
- Homebrew and the apps are installed, so the first run is very slow.
- Afterwards the `darwin-rebuild` command becomes available.

### 4. Later updates
```bash
cd ~/nixos-config
darwin-rebuild switch --flake .#first-darwin
# or, with nh (included in this config)
nh darwin switch -H first-darwin .
```

### 5. Troubleshooting
- `experimental Nix feature 'nix-command' is disabled`: reinstall Lix/Nix, or add `experimental-features = nix-command flakes` to `~/.config/nix/nix.conf`.
- `brew: command not found`: Homebrew is not on PATH yet; open a new terminal.
- **Intel Mac**: this config targets `aarch64-darwin` (Apple Silicon). Set `nixpkgs.hostPlatform = "x86_64-darwin"` in `flake/hosts/freesia/configuration.nix`.

### 6. Switch to `freesia` (optional)
Register the machine's age key in `.sops.yaml`, then switch with `nh darwin switch -H freesia .`. See `modules/sops/default.nix`.

## Rebuild

```bash
nh darwin switch -H first-darwin .
```
