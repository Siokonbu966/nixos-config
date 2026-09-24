{ config, pkgs, lib, ... }:

let
  ignore_apps = [ "steam_app_2777057993" "steam_app_4274141638" ];
  modmap = import ./modmap.nix { inherit ignore_apps; };
  keymap = import ./keymap.nix { inherit ignore_apps; };
  virtual_modifiers = import ./virtual_modifiers.nix;
  userPath = "/run/user/1000";
  deviceNames = [
    "Keychron Keychron Receiver Keyboard" "Keychron Keychron K2" "Keychron B1 Pro Keyboard" "NuPhy NuPhy Air60 V2 Keyboard"
  ];
  deviceArgs = lib.concatStringsSep " " (map (d: "--device '${d}'") deviceNames);
  settingsFormat = pkgs.formats.yaml { };
  configFile = settingsFormat.generate "config.yml" config.services.xremap.config;
  xremap-wrapper = pkgs.writeShellScript "xremap-wrapper" ''
    NIRI_SOCKET=$(ls ${userPath}/niri.wayland-1.*.sock 2>/dev/null | head -1)
    export NIRI_SOCKET
    exec ${config.services.xremap.package}/bin/xremap --mouse ${deviceArgs} ${configFile}
  '';
in
{
  systemd.services.xremap = {
    serviceConfig = {
      ExecStart = lib.mkForce [ "" "${xremap-wrapper}" ];
      BindReadOnlyPaths = [ userPath ];
      InaccessiblePaths = map (x: "-${userPath}/${x}") [
        "app" "bus" "dbus-1" ".dbus-proxy" "dconf" "env-vars"
        ".flatpak" ".flatpak-helper" "gnupg" "pipewire-0" "pipewire-0.lock"
        "pulse" "systemd" "tmux-1000"
      ];
    };
  };

  services.xremap = {
    enable = true;
    withNiri = true;
    mouse = true;
    deviceNames = [
      "Keychron Keychron Receiver Keyboard" "Keychron Keychron K2" "Keychron B1 Pro Keyboard" "NuPhy NuPhy Air60 V2 Keyboard"
    ];
    config = {
      inherit modmap keymap virtual_modifiers;
    };
  };
}
