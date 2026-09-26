{
  inputs,
  ...
}:
let
  inherit (inputs) nixpkgs nixos-wsl home-manager nixvim nix-ld my-dotfiles;
in
nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  specialArgs = {
    device = "wsl";
  };
  modules = [
    nixos-wsl.nixosModules.default
    {
      system.stateVersion = "26.05";
      wsl.enable = true;
      wsl.defaultUser = "crocus";
    }
    nix-ld.nixosModules.nix-ld
    { programs.nix-ld.dev.enable = true; }
    {
      nixpkgs.overlays = [
        (final: prev: {
          ink = final.callPackage ../../pkgs/ink.nix { };
        })
      ];
    }
    ../../hosts/wsl
    ../../modules/font.nix
    ../../modules/fontconfig.nix
    ../../modules/i18n.nix

    home-manager.nixosModules.home-manager {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = {
          inherit
            inputs
            my-dotfiles
          ;
          device = "wsl";
          nixvim-module = nixvim.homeModules.nixvim;
        };
        users.crocus = {
          imports = [
            ../../home/wsl.nix
          ];
        };
      };
    }
  ];
}
