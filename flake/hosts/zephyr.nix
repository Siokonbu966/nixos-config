{ user_name, self, inputs, ... }:
let
  inherit (inputs) nix-darwin nix-homebrew homebrew-core homebrew-cask homebrew-bundle home-manager nixvim my-dotfiles;
in
nix-darwin.lib.darwinSystem {
  specialArgs = { inherit self inputs user_name; };
  modules = [
    ../../hosts/zephyr
    home-manager.darwinModules.home-manager

    nix-homebrew.darwinModules.nix-homebrew
    {
      nix-homebrew = {
        enable = true;
        user = "${user_name}";
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
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        backupFileExtension = "backup";
        extraSpecialArgs = {
          inherit inputs my-dotfiles user_name;
          device = "zephyr";
          nixvim-module = nixvim.homeModules.nixvim;
        };
        users.${user_name} = import ../../home/zephyr.nix;
      };
      nixpkgs.config.allowUnfree = true;
      nixpkgs.overlays = [
        (final: prev: {
          ghtkn = final.callPackage ../../pkgs/ghtkn.nix { };
        })
      ];
    }
  ];
}
