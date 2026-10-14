{ pkgs, inputs, ... }:
{
  services.wivrn = {
    enable = true;
    openFirewall = true;
    autoStart = true;
    steam.importOXRRuntimes = true;
    package = inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.wivrn.override {
      cudaSupport = true;
    };
  };
}
