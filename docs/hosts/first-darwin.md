# `first-darwin`

Bootstrap profile — nix-darwin on `aarch64-darwin`, based on [`freesia`](./freesia.md) but
without sops-nix, so it can be built/activated on a fresh Mac before the host's age key is
registered in `.sops.yaml`.

[日本語版はこちら (Japanese)](./first-darwin.ja.md)

- **Flake entry**: `flake/hosts/first-darwin/` → `darwinConfigurations.first-darwin`
- **nix-darwin config**: imports `flake/hosts/freesia/configuration.nix`
- **Home Manager**: `home/freesia.nix`, user set by `username` in `flake.nix`

## What is excluded (vs `freesia`)

- `modules/sops` + `sops-nix.darwinModules.sops`
- `modules/cachix` (imported by `freesia`'s entrypoint, not by `first-darwin`)

Homebrew (`nix-homebrew` + `brew.nix`), the `pkgs/` overlays, and the full `home/freesia.nix`
are kept.

## Fork this repository

These profiles are personal, so the intended workflow is to **fork the repo** and adapt it to
your own Mac rather than using it directly:

1. On GitHub, press **Fork** to create `<your-name>/nixos-config`.
2. Clone your fork into your home:
   ```bash
   git clone https://github.com/<your-name>/nixos-config ~/nixos-config
   cd ~/nixos-config
   ```
3. Set your username once in `flake.nix`:
   ```nix
   username = "<your-name>";
   ```
4. Commit the changes to your fork. Every command below assumes the repo lives at
   `~/nixos-config`, so they work unchanged.

Keeping your own fork means your secrets (`.sops.yaml`, `secrets/`) and host-specific
settings stay under your control.

## Install guide (new to Nix)

`first-darwin` omits sops, so it can be applied on a fresh Mac even without an age key.

> **One assumption**: run as an **admin** user. Installing Homebrew and the apps
> (Firefox, ghostty, …) needs the admin password and takes tens of minutes.

### 1. Install Lix (recommended) or Nix
On macOS we recommend [Lix](https://lix.systems/), a community fork of Nix with faster
evaluation and friendlier errors:
```bash
curl -sSf -L https://install.lix.systems/lix | sh -s -- install
```
Plain Nix also works if you prefer the [Determinate Systems installer](https://github.com/DeterminateSystems/nix-installer)
(`curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install`).
Open a **new terminal** and confirm with `nix --version` (it should report Lix).

### 2. Clone your fork
```bash
git clone https://github.com/<your-name>/nixos-config ~/nixos-config
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

## Adding back the excluded features

`first-darwin` omits two modules that `freesia` includes. Add them to
`flake/hosts/first-darwin/default.nix` the same way `flake/hosts/freesia/default.nix` does:

| Feature | How to enable |
|---------|---------------|
| sops secrets | Add your Mac's age key to `.sops.yaml`, re-encrypt with `sops updatekeys secrets/example.yaml`, then add `sops-nix.darwinModules.sops` and `../../../modules/sops`. |
| Cachix cache | Add `../../../modules/cachix`. |

Once both are working, you can switch to `freesia` entirely: `nh darwin switch -H freesia .`

## Rebuild

```bash
nh darwin switch -H first-darwin .
```
