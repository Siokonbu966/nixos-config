# `first-linux`

Bootstrap profile — NixOS on `x86_64-linux`, based on [`saffron`](./saffron.md) but with the
pieces that cannot be built/activated on a fresh machine removed (sops secrets and
secret-dependent modules, Secure Boot keys, etc.). Use it to get a first working system,
then switch to `saffron` once the host's age key is registered in `.sops.yaml`.

- **Flake entry**: `flake/hosts/first-linux/` → `nixosConfigurations.first-linux`
- **NixOS config**: `flake/hosts/first-linux/` (`default.nix`, `configuration.nix`, `hardware-configuration.nix`)
- **Hardware**: ships its own copy of saffron's `hardware-configuration.nix`. Replace it with the output of `nixos-generate-config` on the target machine (see the install guide below).
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

## インストール手順（Nix がはじめての人向け）

`first-linux` は sops などの秘密鍵が無くてもビルド・起動できる構成です。ここでは「NixOS の USB から起動して、このリポジトリの設定で実機にインストールする」流れを説明します。

> **前提**: この設定はユーザー名が `crocus` であることを前提にしています。別の名前にしたい場合は、`flake/hosts/first-linux/configuration.nix` と `home/saffron.nix` の中の `crocus` を自分のユーザー名に置き換えてください（`home/saffron.nix` の `homeDirectory = "/home/ユーザー名"` もあわせて変更）。

### 用意するもの
- インストール先の PC（実機）
- 8 GB 以上の USB メモリ（中身は消えます）
- ネットにつながる環境（有線がラク）

### 1. NixOS のインストーラ USB を作る
1. <https://nixos.org/download/> から Graphical ISO（例: `nixos-26.05-x86_64-linux.iso`）をダウンロードします。
2. USB に書き込みます。
   - **Windows**: [Rufus](https://rufus.ie/) を起動 →「選択」で ISO を指定 →「開始」。
   - **macOS / Linux**: ターミナルで。`N` は必ず自分の USB の番号にしてください（**間違えると内蔵ディスクを消します**）。
     ```bash
     diskutil list                                  # macOS: /dev/diskN を確認
     sudo dd if=~/Downloads/nixos-26.05-x86_64-linux.iso of=/dev/rdiskN bs=4m
     sync
     ```

### 2. USB から起動する
1. USB を挿して電源を入れ、すぐに BIOS/UEFI の起動メニュー（F12 / F2 / Esc など）を開き、USB を選びます。
2. NixOS のメニューが出たら一番上（Graphical ISO）を選びます。
3. ネットにつなぎます。有線ならそのまま。Wi-Fi なら:
   ```bash
   nmcli device wifi list
   nmcli device wifi connect "SSID" password "パスワード"
   ip a          # 192.168. など IP が付けば OK
   ```

### 3. ディスクを準備する（新規インストール時）
`lsblk` で実機のディスク名を確認します（以下は `/dev/nvme0n1` の例）。**ディスク名は必ず自分の環境に合わせてください。**
```bash
lsblk
sudo -i
parted /dev/nvme0n1 -- mklabel gpt
parted /dev/nvme0n1 -- mkpart ESP fat32 1MiB 512MiB
parted /dev/nvme0n1 -- set 1 esp on
parted /dev/nvme0n1 -- mkpart root ext4 512MiB 100%
mkfs.fat -F 32 -n boot /dev/nvme0n1p1
mkfs.ext4 -L nixos /dev/nvme0n1p2
mount /dev/disk/by-label/nixos /mnt
mkdir -p /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot
```

### 4. このリポジトリの設定でインストール
root のまま続けます:
```bash
git clone https://github.com/Siokonbu966/nixos-config /root/nixos-config
cd /root/nixos-config

# 実機のハードウェア情報を生成して、first-linux のものと差し替える
nixos-generate-config --root /mnt
cp /mnt/etc/nixos/hardware-configuration.nix flake/hosts/first-linux/hardware-configuration.nix
git add flake/hosts/first-linux/hardware-configuration.nix

# インストール（root パスワードを聞かれたら設定する）
nixos-install --flake .#first-linux --root /mnt
```

インストールが終わったら、ログイン用のパスワードを設定します:
```bash
nixos-enter --root /mnt -c 'passwd crocus'
```

### 5. 再起動する
```bash
reboot
```
USB を抜いて内蔵ディスクから起動します。ログイン画面（niri）が出れば成功です。

### 6. 日常の更新
ホームにリポジトリを置き直します（`nh` はこの設定に含まれています）:
```bash
git clone https://github.com/Siokonbu966/nixos-config ~/nixos-config
cd ~/nixos-config
nh os switch -H first-linux .
```

### 7. 本番の `saffron` に切り替える（任意）
`first-linux` は秘密情報を扱わないための bootstrap です。実機の age 鍵を `.sops.yaml` に登録し、`secrets/` を再暗号化したあと、`nh os switch -H saffron .` で本来の設定に切り替えられます。鍵の登録方法は `modules/sops/default.nix` と [sops-nix](https://github.com/Mic92/sops-nix) を参照してください。

## Rebuild

```bash
nh os switch -H first-linux .
```
