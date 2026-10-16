{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    cachix
  ];

  nix = {
    settings = {
      substituters = [
        "https://siokonbu966.cachix.org"
        "https://kopuz.cachix.org"
      ];
      trusted-public-keys = [
        "siokonbu966.cachix.org-1:RrvzXSLjP8pq8fgMSeI62P5l19lLinBd5cYSF017pKg="
        "kopuz.cachix.org-1:J2X3AnAYhKTJW5S3aCLoA1ckonQXVNZMQvhZA0YAufw="
      ];
    };
  };
}
