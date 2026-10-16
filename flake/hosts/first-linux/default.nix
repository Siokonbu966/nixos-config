{
  inputs,
  username,
  ...
}:
let
  inherit (inputs) nixpkgs home-manager nixvim nix-ld xwayland-satellite my-dotfiles noctalia;
in
nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  specialArgs = {
    device = "saffron";
    inherit inputs username;
  };
  modules = [
    ./configuration.nix
    ../../../nvidia
    nix-ld.nixosModules.nix-ld
    { programs.nix-ld.dev.enable = true; }
    {
      nixpkgs.overlays = [
        xwayland-satellite.overlays.default
        (final: prev: {
          buzz-sidecars = final.callPackage ../../../pkgs/buzz-sidecars.nix { };
          buzz-desktop = final.callPackage ../../../pkgs/buzz-desktop.nix {
            inherit (final) buzz-sidecars;
          };
          ink = final.callPackage ../../../pkgs/ink.nix { };
          effectcraft = final.callPackage ../../../pkgs/effectcraft.nix { };
          souieba = final.callPackage ../../../pkgs/souieba.nix { };
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
            username
          ;
          device = "saffron";
          nixvim-module = nixvim.homeModules.nixvim;
        };
        users.${username} = {
          imports = [
            noctalia.homeModules.default
            ../../../home/saffron.nix
          ];
        };
      };
    }
  ];
}
