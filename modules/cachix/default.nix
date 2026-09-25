{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    cachix
  ];

  nix = {
    settings = {
      substituters = [
        "https://siokonbu966.cachix.org"
      ];
      trusted-public-keys = [
        "siokonbu966.cachix.org-1:RrvzXSLjP8pq8fgMSeI62P5l19lLinBd5cYSF017pKg="
      ];
    };
  };
}
