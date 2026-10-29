{ username, self, inputs, ... }:
let
  inherit (inputs) nix-darwin nix-homebrew homebrew-core homebrew-cask homebrew-bundle home-manager nixvim my-dotfiles sops-nix;
in
nix-darwin.lib.darwinSystem {
  specialArgs = { inherit self inputs username; };
  modules = [
    ./configuration.nix
    home-manager.darwinModules.home-manager
    sops-nix.darwinModules.sops

    nix-homebrew.darwinModules.nix-homebrew
    {
      nixpkgs.overlays = [
        (final: prev: {
          # Self-built, pinned ahead of nixpkgs (nixpkgs' cloudflared lags releases).
          cloudflared = final.callPackage ../../../pkgs/cloudflared.nix { };
        })
      ];
    }
    {
      nix-homebrew = {
        enable = true;
        user = "${username}";
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
          inherit inputs my-dotfiles username;
          device = "zephyr";
          nixvim-module = nixvim.homeModules.nixvim;
        };
        users.${username} = import ../../../home/zephyr.nix;
      };
      nixpkgs.config.allowUnfree = true;
    }
  ];
}
