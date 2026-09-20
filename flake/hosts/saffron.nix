{
  inputs,
  ...
}:
let
  inherit (inputs) nixpkgs home-manager nixvim nix-ld xremap-flake noctalia my-dotfiles lanzaboote xwayland-satellite;
in
nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  specialArgs = {
    device = "saffron";
  };
  modules = [
    ../../hosts/saffron
    ../../nvidia
    lanzaboote.nixosModules.lanzaboote
    xremap-flake.nixosModules.default
    ../../modules/xremap
    ../../modules/wm
    ../../modules/game
    nix-ld.nixosModules.nix-ld
    { programs.nix-ld.dev.enable = true; }

    {
      nixpkgs.overlays = [
        xwayland-satellite.overlays.default
        (final: prev: {
          buzz-sidecars = final.callPackage ../../pkgs/buzz-sidecars.nix { };
          buzz-desktop = final.callPackage ../../pkgs/buzz-desktop.nix {
            inherit (final) buzz-sidecars;
          };
          ink = final.callPackage ../../pkgs/ink.nix { };
        })
      ];
    }

    home-manager.nixosModules.home-manager {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        backupFileExtension = "backup";
        extraSpecialArgs = {
          inherit
            inputs
            my-dotfiles
          ;
          device = "saffron";
          nixvim-module = nixvim.homeModules.nixvim;
        };
        users.crocus = {
          imports = [
            noctalia.homeModules.default
            ../../home/saffron.nix
          ];
        };
      };
    }
  ];
}
