{
  inputs,
  username,
  isCI ? false,
  ...
}:
let
  inherit (inputs) nixpkgs home-manager nixvim nix-ld xremap-flake noctalia my-dotfiles lanzaboote xwayland-satellite sops-nix repro2;
in
nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  specialArgs = {
    device = "saffron";
    inherit isCI inputs username;
  };
  modules = [
    ./configuration.nix
    sops-nix.nixosModules.sops
    xremap-flake.nixosModules.default
    repro2.nixosModules.default
    {
      services.repro2-sender = {
        enable = true;
        registryUrl = "https://repro2-test-server.tail07452a.ts.net:8443/";
        blobUrl = "https://repro2-test-server.tail07452a.ts.net:8444/";
      };
    }
    nix-ld.nixosModules.nix-ld
    { programs.nix-ld.dev.enable = true; }
  ]
  ++ nixpkgs.lib.optionals (!isCI) [
    ../../../nvidia
    lanzaboote.nixosModules.lanzaboote
  ]
  ++ [
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
          rea = final.callPackage ../../../pkgs/rea.nix { };
          ollama = final.callPackage ../../../pkgs/ollama.nix {
            ollama = inputs.nixpkgs-unstable.legacyPackages.${final.stdenv.hostPlatform.system}.ollama;
          };
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
