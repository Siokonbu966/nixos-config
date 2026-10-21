{
  inputs,
  username,
  ...
}:
let
  inherit (inputs) nixpkgs home-manager nixvim nix-ld xremap-flake my-dotfiles;
in
nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  specialArgs = {
    device = "surface";
    inherit username;
  };
  modules = [
    ./configuration.nix
    xremap-flake.nixosModules.default
    ../../../modules/xremap
    nix-ld.nixosModules.nix-ld
    { programs.nix-ld.dev.enable = true; }

    home-manager.nixosModules.home-manager {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = {
          inherit
            inputs
            my-dotfiles
            username
          ;
          device = "surface";
          nixvim-module = nixvim.homeModules.nixvim;
        };
        users.${username} = {
          imports = [
            ../../../home/surface.nix
          ];
        };
      };
    }
  ];
}
