{...}:
{
  imports = [
    ../../../configuration.nix
    ./hardware-configuration.nix
  ];

  programs.dconf.enable = true;

  services.tailscale.enable = true;

  hardware.graphics.enable = true;

  networking.hostName = "coccineus";
  networking.interfaces.enp0s20f0u1u1u4.ipv4.addresses = [{
    address = "192.168.0.18";
    prefixLength = 24;
  }];
}
