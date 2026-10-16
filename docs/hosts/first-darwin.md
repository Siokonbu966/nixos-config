# `first-darwin`

Bootstrap profile — nix-darwin on `aarch64-darwin`, based on [`freesia`](./freesia.md) but
without sops-nix, so it can be built/activated on a fresh Mac before the host's age key is
registered in `.sops.yaml`.

- **Flake entry**: `flake/hosts/first-darwin/` → `darwinConfigurations.first-darwin`
- **nix-darwin config**: imports `flake/hosts/freesia/configuration.nix`
- **Home Manager**: `home/freesia.nix`, user `crocus`

## What is excluded (vs `freesia`)

- `modules/sops` + `sops-nix.darwinModules.sops`
- `modules/cachix` (imported by `freesia`'s entrypoint, not by `first-darwin`)

Homebrew (`nix-homebrew` + `brew.nix`), the `pkgs/` overlays, and the full `home/freesia.nix`
are kept.

## インストール手順（Nix がはじめての人向け）

`first-darwin` は sops を含まないので、age 鍵が無い新しい Mac でもそのまま適用できます。

> **前提（2 点）**
> 1. この設定はユーザー名が `crocus`（ホーム `/Users/crocus`）である前提です。別の名前の場合、次の 3 ファイルの `crocus` を自分のユーザー名に置き換えてください: `flake/hosts/freesia/configuration.nix`、`flake/hosts/first-darwin/default.nix`、`home/freesia.nix`（`homeDirectory` も）。
> 2. **管理者（admin）ユーザー**で実行してください。Homebrew と各種アプリ（Firefox, ghostty など）の導入に、管理者パスワードと数十分かかります。

### 1. Nix をインストールする
[Determinate Systems installer](https://github.com/DeterminateSystems/nix-installer) を使うと flakes が最初から有効で簡単です:
```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```
終わったら**新しいターミナルを開き**、`nix --version` で確認します。

### 2. リポジトリを取得する
```bash
git clone https://github.com/Siokonbu966/nixos-config ~/nixos-config
cd ~/nixos-config
```
`git` が無い場合は `xcode-select --install` で入ります。

### 3. 初回適用する
```bash
nix run nix-darwin -- switch --flake ~/nixos-config#first-darwin
```
- 途中で管理者パスワードを聞かれます。
- Homebrew・アプリの導入が入るため、初回はとても時間がかかります。
- 完了すると `darwin-rebuild` コマンドが使えるようになります。

### 4. 2 回目以降の更新
```bash
cd ~/nixos-config
darwin-rebuild switch --flake .#first-darwin
# または、この設定に含まれる nh で
nh darwin switch -H first-darwin .
```

### 5. うまくいかないとき
- `experimental Nix feature 'nix-command' is disabled`: Nix を入れ直すか、`~/.config/nix/nix.conf` に `experimental-features = nix-command flakes` を追加してください。
- `brew: command not found` など: Homebrew がまだ PATH に入っていないだけです。ターミナルを開き直してください。
- **Intel Mac** の場合: この設定は `aarch64-darwin`（Apple Silicon）前提です。`flake/hosts/freesia/configuration.nix` の `nixpkgs.hostPlatform` を `x86_64-darwin` に変更してください。

### 6. 本番の `freesia` に切り替える（任意）
実機の age 鍵を `.sops.yaml` に登録したあと、`nh darwin switch -H freesia .` で本来の設定に切り替えられます。鍵の登録方法は `modules/sops/default.nix` を参照してください。

## Rebuild

```bash
nh darwin switch -H first-darwin .
```
