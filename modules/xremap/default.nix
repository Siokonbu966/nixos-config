{ config, pkgs, ... }:

let
  modmap = import ./modmap.nix;
  keymap = import ./keymap.nix;
  virtual_modifiers = import ./virtual_modifiers.nix;
in
{
  services.xremap = {
    enable = true;
    deviceNames = [
      "Keychron Keychron Receiver Keyboard" "Keychron Keychron K2" "Keychron B1 Pro Keyboard" "NuPhy NuPhy Air60 V2 Keyboard"
    ];
    config = {
      inherit modmap keymap virtual_modifiers;
    };
  };
}
