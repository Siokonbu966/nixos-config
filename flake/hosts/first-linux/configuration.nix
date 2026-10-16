{ pkgs, ... }:
{
  imports = [
    ../../../configuration.nix
    ../saffron/hardware-configuration.nix
    ../../../modules/wm
    ../../../modules/game
    ../../../modules/vr
  ];

  networking.hostName = "nixos";

  hardware.brillo.enable = true;
  hardware.i2c.enable = true;
  programs.obs-studio.enableVirtualCamera = true;

  services.tailscale.enable = true;

  environment.systemPackages = with pkgs; [
    xwayland-satellite
  ];

  boot.kernelModules = [ "v4l2loopback" ];
}
