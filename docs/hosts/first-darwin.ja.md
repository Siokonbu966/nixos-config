# `first-darwin`

bootstrap 用プロファイル — `aarch64-darwin` の nix-darwin。[`freesia`](./freesia.md) をベースに sops-nix を取り除いた構成で、age 鍵が無い新しい Mac でも適用できます。

[English (英語版)](./first-darwin.md)

- **Flake エントリ**: `flake/hosts/first-darwin/` → `darwinConfigurations.first-darwin`
- **nix-darwin 設定**: `flake/hosts/freesia/configuration.nix` を import
- **Home Manager**: `home/freesia.nix`、ユーザーは `flake.nix` の `username`

## 除外されるもの（`freesia` との比較）

- `modules/sops` + `sops-nix.darwinModules.sops`
- `modules/cachix`（`freesia` のエントリポイントで import しているため `first-darwin` には入りません）

Homebrew（`nix-homebrew` + `brew.nix`）、`pkgs/` の overlay、`home/freesia.nix` 一式はそのまま使います。

## このリポジトリを fork して使う

このプロファイルは個人向けなので、そのまま使うのではなく **fork して自分の Mac 向けに調整**する前提です:

1. GitHub で **Fork** を押して `<your-name>/nixos-config` を作る。
2. fork をホームに clone する:
   ```bash
   git clone https://github.com/<your-name>/nixos-config ~/nixos-config
   cd ~/nixos-config
   ```
3. `flake.nix` の `username` を自分の名前に変える:
   ```nix
   username = "<your-name>";
   ```
4. 変更を fork にコミットする。以降のコマンドはリポジトリが `~/nixos-config` にある前提なので、そのまま使えます。

自分の fork にしておくことで、シークレット（`.sops.yaml`, `secrets/`）やホスト固有の設定を自分で管理できます。

## インストール手順（Nix がはじめての人向け）

`first-darwin` は sops を含まないので、age 鍵が無い新しい Mac でもそのまま適用できます。

> **前提**: **管理者（admin）ユーザー**で実行してください。Homebrew と各種アプリ（Firefox, ghostty など）の導入に、管理者パスワードと数十分かかります。

### 1. Lix（推奨）または Nix をインストールする
macOS では Nix のコミュニティ fork である [Lix](https://lix.systems/) を推奨します（評価が速く、エラーも分かりやすい）:
```bash
curl -sSf -L https://install.lix.systems/lix | sh -s -- install
```
通常の Nix でも動きます。その場合は [Determinate Systems installer](https://github.com/DeterminateSystems/nix-installer) を同じオプションで使ってください（`curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install`）。
終わったら**新しいターミナルを開き**、`nix --version` で確認します（Lix と表示されます）。

### 2. 自分の fork を clone する
```bash
git clone https://github.com/<your-name>/nixos-config ~/nixos-config
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
- `experimental Nix feature 'nix-command' is disabled`: Lix / Nix を入れ直すか、`~/.config/nix/nix.conf` に `experimental-features = nix-command flakes` を追加してください。
- `brew: command not found` など: Homebrew がまだ PATH に入っていないだけです。ターミナルを開き直してください。
- **Intel Mac** の場合: この設定は `aarch64-darwin`（Apple Silicon）前提です。`flake/hosts/freesia/configuration.nix` の `nixpkgs.hostPlatform` を `x86_64-darwin` に変更してください。

## 除外した機能を後から有効にする

`first-darwin` は `freesia` が持つ 2 つのモジュールを省いています。`flake/hosts/freesia/default.nix` と同じように `flake/hosts/first-darwin/default.nix` に足し戻します:

| 機能 | 有効にする方法 |
|------|----------------|
| sops シークレット | 実機の age 鍵を `.sops.yaml` に登録し、`sops updatekeys secrets/example.yaml` で再暗号化。その後 `sops-nix.darwinModules.sops` と `../../../modules/sops` を追加。 |
| Cachix キャッシュ | `../../../modules/cachix` を追加。 |

両方が動くようになったら、`nh darwin switch -H freesia .` で `freesia` にそのまま移行できます。

## リビルド

```bash
nh darwin switch -H first-darwin .
```
