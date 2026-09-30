{ pkgs, lib, ... }:
let
  isCi = builtins.getEnv "GITHUB_ACTIONS" == "true" || builtins.getEnv "CI" == "true";
in
{
  imports = [
    ../../configuration.nix
    ./hardware-configuration.nix
    ../../modules/secureboot.nix
  ];

  networking.hostName = "saffron";

  networking.interfaces.enp10s0.ipv4.addresses = [{
    address = "192.168.0.92";
    prefixLength = 24;
  }];

  hardware.brillo.enable = true;
  hardware.i2c.enable = true;
  programs.obs-studio.enableVirtualCamera = true;

  # vmware
  virtualisation.vmware.host.enable = !isCi;
  services.xserver.videoDrivers = lib.optionals (!isCi) [ "vmware" ];

  services.tailscale.enable = true;

  environment.systemPackages = with pkgs; [
    xwayland-satellite
  ];

  boot.kernelModules = [ "v4l2loopback" ];
}
