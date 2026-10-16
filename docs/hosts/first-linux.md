# `first-linux`

Bootstrap profile — NixOS on `x86_64-linux`, based on [`saffron`](./saffron.md) but with the
pieces that cannot be built/activated on a fresh machine removed (sops secrets and
secret-dependent modules, Secure Boot keys, etc.). Use it to get a first working system,
then switch to `saffron` once the host's age key is registered in `.sops.yaml`.

[日本語版はこちら (Japanese)](./first-linux.ja.md)

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

## Install guide (new to Nix)

`first-linux` can be built and booted without any secrets such as sops. This walks through
"boot from a NixOS USB, then install this repo's config onto the machine".

> **Assumption**: this config assumes the username `crocus`. To use another name, replace
> `crocus` in `flake/hosts/first-linux/configuration.nix` and `home/saffron.nix` (including
> `homeDirectory = "/home/<name>"`).

### What you need
- The target PC
- A USB stick of 8 GB or more (it will be erased)
- A network connection (wired is easiest)

### 1. Create a NixOS installer USB
1. Download a Graphical ISO (e.g. `nixos-26.05-x86_64-linux.iso`) from <https://nixos.org/download/>.
2. Write it to the USB:
   - **Windows**: open [Rufus](https://rufus.ie/), pick the ISO, press Start.
   - **macOS / Linux**: in a terminal. `N` must be your USB device number (**picking the wrong one erases your internal disk**).
     ```bash
     diskutil list                                  # macOS: find /dev/diskN
     sudo dd if=~/Downloads/nixos-26.05-x86_64-linux.iso of=/dev/rdiskN bs=4m
     sync
     ```

### 2. Boot from the USB
1. Insert the USB, power on, and open the boot menu (F12 / F2 / Esc, …) to select the USB.
2. Choose the top entry (Graphical ISO).
3. Get online. Wired works out of the box; for Wi-Fi:
   ```bash
   nmcli device wifi list
   nmcli device wifi connect "SSID" password "password"
   ip a          # an IP such as 192.168.x.x means you are online
   ```

### 3. Prepare the disks (fresh install)
Use `lsblk` to find your disk (the example below uses `/dev/nvme0n1`). **Use your real device name.**
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

### 4. Install with this repo's config
Still as root:
```bash
git clone https://github.com/Siokonbu966/nixos-config /root/nixos-config
cd /root/nixos-config

# generate this machine's hardware config and drop it in
nixos-generate-config --root /mnt
cp /mnt/etc/nixos/hardware-configuration.nix flake/hosts/first-linux/hardware-configuration.nix
git add flake/hosts/first-linux/hardware-configuration.nix

# install (set a root password when prompted)
nixos-install --flake .#first-linux --root /mnt
```
Then set a login password:
```bash
nixos-enter --root /mnt -c 'passwd crocus'
```

### 5. Reboot
```bash
reboot
```
Remove the USB and boot from the internal disk. Seeing the niri login greeter means success.

### 6. Day-to-day updates
Put the repo in your home (`nh` ships with this config):
```bash
git clone https://github.com/Siokonbu966/nixos-config ~/nixos-config
cd ~/nixos-config
nh os switch -H first-linux .
```

### 7. Switch to `saffron` (optional)
`first-linux` exists to avoid touching secrets. Register the machine's age key in
`.sops.yaml`, re-encrypt `secrets/`, then switch with `nh os switch -H saffron .`. See
`modules/sops/default.nix` and [sops-nix](https://github.com/Mic92/sops-nix).

## Rebuild

```bash
nh os switch -H first-linux .
```
