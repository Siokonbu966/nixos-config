# xremap

[`xremap`](https://github.com/xremap/xremap) is a key remapper that works per-application on Wayland (via niri) and X11. In this repo it implements a custom keyboard layout and multi-layer keymap.

## Where it lives

| Piece | Path | Role |
|-------|------|------|
| NixOS module | `modules/xremap/` | Runs the `xremap` **service** (layout, layers, mouse buttons) |
| Home Manager module | `home/programs/xremap/default.nix` | Installs the `xremap` **CLI** for manual/debug use |
| Flake input | `flake.nix` → `xremap-flake` | Provides `nixosModules.default` (the `services.xremap` options) |

### Enabled on

- `saffron`: `flake/hosts/saffron.nix` imports `xremap-flake.nixosModules.default` + `modules/xremap`; `home/saffron.nix` imports `./programs/xremap`.
- `surface`: same imports in `flake/hosts/surface.nix` + `home/surface.nix`.
- Not used on `wsl`, `freesia`, or `zephyr`.

The root `configuration.nix` also imports `./modules/xremap`, so any host importing it picks the module up.

## Module structure

`modules/xremap/default.nix` builds the `services.xremap.config` from three imported files:

```
modules/xremap/
├── default.nix            # service wiring, devices, NIRI_SOCKET wrapper
├── modmap.nix             # base layout remap (layer 0) + layer activators
├── keymap.nix             # layer 1 / layer 2 mappings + app-specific remaps
└── virtual_modifiers.nix  # declares the virtual modifier keys
```

## Devices

Only these keyboards are remapped (by exact device name):

- `Keychron Keychron Receiver Keyboard`
- `Keychron Keychron K2`
- `Keychron B1 Pro Keyboard`
- `NuPhy NuPhy Air60 V2 Keyboard`

The K2 is treated as **JIS**; the others as **US** (see `modmap.nix` `device.only`).

## Layout layers

### `modmap.nix` — base layer

A custom logical layout applied to every key on all devices (unless the app is ignored). It remaps the physical QWERTY positions, e.g. `a → e`, `r → f`, `s → i`, `d → a`, plus:

- Modifier relocation: `h → Shift_L`, `b → Alt_R`, `n → Ctrl_L`.
- Layout activation combos (`free_hold = true`): hold to get the virtual modifier, tap to get the letter.
  - `Slash` → held `Menu` / alone `j` (IME toggle)
  - `z` → held `Menu` / alone `x`

The **JIS** and **US** groups add device-specific keys:

| | JIS (K2) | US |
|-|----------|-----|
| letter swaps | `RO→b`, `Backslash→p`, `Muhenkan→Enter` | `Shift_R→b`, `Enter→p`, `Delete→Print` |
| Layer 1 activator | `Space` → held `Insert` / alone `Backspace` | `Space` → held `Insert` / alone `Backspace` |
| Layer 2 activator | `Henkan` → held `ScrollLock` / alone `Space` | `Alt_R` → held `ScrollLock` / alone `Space` |
| extra | — | `Alt_L` → held `Alt_L` / alone `Enter` |

### `virtual_modifiers.nix`

Declares the virtual modifiers the layers are built on:

- `Insert` — Layer 1
- `ScrollLock` — Layer 2
- `Menu` — IME toggle

### `keymap.nix` — layer mappings

- **Layer 1 (`Insert`)** — number row / symbols: `Insert-e → 0`, `Insert-u → 2`, `Insert-f → 3`, `Insert-i → 4`, `Insert-a → 5`, `Insert-o → 6`, `Insert-x → 7`, `Insert-c → 8`, `Insert-v → 9`, `Insert-z → $`, and much more (see the file).
- **Layer 2 (`ScrollLock`)** — symbols and controls: brackets/braces, `#`, `` ` ``, `'`, `"`, `@`, `|`, `&`, `%`, `~`; `Esc`; arrow keys (`Left/Up/Down/Right`); media (`VolumeUp`, `VolumeDown`, `NextSong`, `PreviousSong`, `StopCD` — via `playerctl`); and `ScrollLock-LeftBrace → CapsLock`.
- **`other`** — `Kp0 → Shift-Equal` (`+`), `Menu-c → C-Space` (IME: us), `Menu-m → C-Backslash` (IME: jp).
- **`steam-mouse`** — mouse side buttons mapped to `l`/`m` (with `BTN_BACK`/`BTN_FORWARD` fallbacks) for `steam_app_4274141638`.

### Ignored applications

`ignore_apps = [ "steam_app_2777057993" "steam_app_4274141638" ]` — the layout is not applied inside these apps (except the dedicated `steam-mouse` rule).

## Service wiring (`modules/xremap/default.nix`)

- `services.xremap` with `enable`, `withNiri = true`, `mouse = true`, `deviceNames`, and the generated `config`.
- A wrapper script exports `NIRI_SOCKET` (found under `/run/user/1000/niri.wayland-1.*.sock`) and execs `xremap --mouse <device args> <generated config.yml>`.
- Sandboxing: `BindReadOnlyPaths = [ "/run/user/1000" ]` and `InaccessiblePaths` hides unrelated runtime paths (`app`, `bus`, `dconf`, `gnupg`, `pipewire-0`, `pulse`, `systemd`, `tmux-1000`, …).

## Editing

- Change the layout in `modules/xremap/modmap.nix` (base) or `modules/xremap/keymap.nix` (layers).
- Add a new device by appending its exact name to `deviceNames` in `modules/xremap/default.nix` and the relevant `device.only` list in `modmap.nix`.
- After editing, rebuild the host and reload the service:

```bash
nh os switch -H saffron .
systemctl --user status xremap   # if enabled as a user service
```
