{ pkgs, inputs, ... }:
{
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    extraCompatPackages = with inputs.nixpkgs-unstable; [
      proton-ge-bin
    ];
  };

  programs.gamemode.enable = true;
}
