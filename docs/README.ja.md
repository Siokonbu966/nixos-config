# nixos-config

Nix Flake ベースの NixOS / nix-darwin / Home Manager 設定リポジトリ。

[English (英語版)](../README.md)

## ホスト構成

| ホスト | OS | 用途 | エントリポイント |
|--------|----|------|------------------|
| `saffron` | NixOS (x86_64) | メインのデスクトップ | `flake/hosts/saffron.nix`, `hosts/saffron/`, `home/saffron.nix` |
| `saffron-ci` | NixOS (x86_64) | CI 用バリアント (`isCI = true`)。nvidia/secureboot/vmware なし | saffron と同じ |
| `surface` | NixOS (x86_64) | Surface デバイス | `flake/hosts/surface.nix`, `hosts/surface/`, `home/surface.nix` |
| `wsl` | NixOS (WSL) | WSL 環境 | `flake/hosts/wsl.nix`, `hosts/wsl/`, `home/wsl.nix` |
| `freesia` | nix-darwin (aarch64) | macOS | `flake/hosts/freesia.nix`, `hosts/freesia/`, `home/freesia.nix` |
| `zephyr` | nix-darwin (aarch64) | macOS | `flake/hosts/zephyr.nix`, `hosts/zephyr/`, `home/zephyr.nix` |

ホストごとの詳細は [`docs/hosts/`](./hosts/README.md) を参照 (英語)。

## ディレクトリ構成

```
.
├── flake.nix               # Flake エントリポイント (inputs + outputs)
├── flake/hosts/            # ホスト別 Flake 定義 (saffron, surface, wsl, freesia, zephyr)
├── configuration.nix       # 共通 NixOS 設定 (saffron/surface から import)
├── hosts/                  # ホスト別設定
│   ├── saffron/
│   ├── surface/
│   ├── wsl/
│   ├── freesia/
│   └── zephyr/
├── modules/                # 共通 NixOS モジュール
│   ├── boot.nix
│   ├── font.nix
│   ├── i18n.nix
│   ├── network/            # ネットワーク / wifi
│   ├── sops/               # sops-nix によるシークレット
│   ├── secureboot.nix
│   ├── wm/                 # ウィンドウマネージャ (niri, sway, noctalia)
│   └── xremap/
├── home/                   # Home Manager 設定
│   ├── saffron.nix         # ホスト別 HM エントリ
│   ├── surface.nix
│   ├── wsl.nix
│   ├── freesia.nix
│   ├── zephyr.nix
│   ├── programs/           # プログラム別 HM モジュール
│   └── tools/
├── pkgs/                   # カスタムパッケージ (overlay 経由で公開)
├── nvidia/                 # NVIDIA 設定
├── configs/                # ドットファイル・raw 設定
└── secrets/                # sops で暗号化したシークレット
```

## ビルドコマンド

```bash
# NixOS (saffron / saffron-ci / surface / wsl) — 推奨
nh os switch -H <host> .

# nix-darwin (freesia / zephyr) — 推奨
nh darwin switch -H <host> .

# フォールバック
sudo nixos-rebuild switch --flake .#<host>
darwin-rebuild switch --flake .#<host>

# Dry run (テスト)
nh os switch -n
nh darwin switch -n
```

Nix の変更を完了とする前に、Flake が評価できることを確認する:

```bash
nix eval '.#nixosConfigurations.<host>.config.system.build.toplevel.drvPath'
nix eval '.#darwinConfigurations.<host>.config.system.build.toplevel.drvPath'
```

CI は `.#nixosConfigurations.saffron-ci...toplevel` と `.#darwinConfigurations.freesia...toplevel` を参照ビルドターゲットとして使用する。

## ドキュメント

- [ホストごとの詳細](./hosts/README.md) (英語)
- [xremap](./xremap.md) — 独自キーボードレイアウトとレイヤー (英語)

## 補足

- Home Manager は NixOS/darwin モジュールとして組み込まれている (`useGlobalPkgs = true`)。単体で `home-manager switch` は実行しない。
- シークレットは sops-nix を使用: ホスト別 age キーは `.sops.yaml`、暗号化ファイルは `secrets/`。リポジトリに平文のシークレットを置かない。
- `pkgs/` のカスタムパッケージは各 `flake/hosts/*.nix` の `nixpkgs.overlays` 経由で公開する (overlay の構成はホストごとに異なる)。
- Nixvim は `nixvim.homeModules.nixvim` を通して評価される。編集するのは `home/programs/nixvim/`。
- OpenCode の設定は `home/programs/opencode/default.nix` から `xdg.configFile` に生成される。生成された JSON ではなく Nix ファイルを編集する。
- Flake の input は自動更新される (`.github/workflows/update-flake.yml`)。`flake.lock` を手で編集しない。
