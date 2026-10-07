{ pkgs, lib, isCI ? false, ... }:
{
  imports = [
    ../../configuration.nix
    ./hardware-configuration.nix
  ]
  ++ lib.optionals (!isCI) [
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
  virtualisation.vmware.host.enable = !isCI;
  services.xserver.videoDrivers = lib.mkIf (!isCI) [ "vmware" ];

  services.tailscale.enable = true;

  environment.systemPackages = with pkgs; [
    xwayland-satellite
  ];

  boot.kernelModules = [ "v4l2loopback" ];

  systemd.services.mic-input-source = {
    description = "Default mic input source: case front mic";
    wantedBy = [ "multi-user.target" ];
    after = [ "sound.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = "${pkgs.alsa-utils}/bin/amixer -c 2 cset numid=20 1";
  };
}
