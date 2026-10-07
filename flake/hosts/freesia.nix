{
  self,
  inputs,
  ...
}:
let
  inherit (inputs) nix-darwin nix-homebrew homebrew-core homebrew-cask homebrew-bundle home-manager nixvim my-dotfiles;
in
nix-darwin.lib.darwinSystem {
  specialArgs = { inherit self inputs; };
  modules = [
    ../../hosts/freesia
    home-manager.darwinModules.home-manager

    nix-homebrew.darwinModules.nix-homebrew
    {
      nix-homebrew = {
        enable = true;
        user = "crocus";
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
          omniwm = final.callPackage ../../pkgs/omniwm.nix { };
          ink = final.callPackage ../../pkgs/ink.nix { };
          effectcraft = final.callPackage ../../pkgs/effectcraft.nix { };
          ghtkn = final.callPackage ../../pkgs/ghtkn.nix { };
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
          ;
          nixvim-module = nixvim.homeModules.nixvim;
          device = "freesia";
        };
        users.crocus = import ../../home/freesia.nix;
      };
      nixpkgs.config.allowUnfree = true;
    }
  ];
}
