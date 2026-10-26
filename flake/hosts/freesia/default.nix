{
  self,
  inputs,
  username,
  ...
}:
let
inherit (inputs) nix-darwin nix-homebrew homebrew-core homebrew-cask homebrew-bundle home-manager nixvim my-dotfiles sops-nix;
in
nix-darwin.lib.darwinSystem {
  specialArgs = { inherit self inputs username; };
  modules = [
    ./configuration.nix
    home-manager.darwinModules.home-manager
    ../../../modules/cachix
    ../../../modules/sops
    sops-nix.darwinModules.sops

    nix-homebrew.darwinModules.nix-homebrew
    {
      nix-homebrew = {
        enable = true;
        user = username;
        autoMigrate = true;
        taps = {
          "homebrew/homebrew-core" = homebrew-core;
          "homebrew/homebrew-cask" = homebrew-cask;
          "homebrew/homebrew-bundle" = homebrew-bundle;
        };
        mutableTaps = false;
      };
    }
    ({ config, ... }: {
      homebrew.taps = builtins.attrNames config.nix-homebrew.taps;
    })
    {
      nixpkgs.overlays = [
        (final: prev: {
          ink = final.callPackage ../../../pkgs/ink.nix { };
          effectcraft = final.callPackage ../../../pkgs/effectcraft.nix { };
          souieba = final.callPackage ../../../pkgs/souieba.nix { };
          rea = final.callPackage ../../../pkgs/rea.nix { };
          protobuf = prev.protobuf.overrideAttrs (_: {
            doCheck = false;
          });
        })
      ];
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        backupFileExtension = "backup";
        extraSpecialArgs = {
          inherit
            inputs
            my-dotfiles
            username
          ;
          nixvim-module = nixvim.homeModules.nixvim;
          device = "freesia";
        };
        users.${username} = import ../../../home/freesia.nix;
      };
      nixpkgs.config.allowUnfree = true;
    }
  ];
}
