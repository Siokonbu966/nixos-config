{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    my-dotfiles = {
      url = "github:Siokonbu966/dotfiles";
      flake = false;
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia/legacy-v4";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim/nixos-26.05";
    };
    nix-ld = {
      url = "github:Mic92/nix-ld";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    xremap-flake.url = "github:xremap/nix-flake";
    nix-homebrew = {
      url = "github:zhaofengli/nix-homebrew";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
    herdr = {
      url = "github:ogulcancelik/herdr/v0.7.3";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.1.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts.url = "github:hercules-ci/flake-parts";
    opencode.url = "github:anomalyco/opencode/v1.18.31";
  };

  outputs = {
    self,
    flake-parts,
    ...
  }@inputs:
  flake-parts.lib.mkFlake { inherit inputs; } {
    flake = {
      darwinConfigurations = {
        "freesia" = import ./flake/hosts/freesia.nix {
          inherit self inputs;
        };

        "zephyr" = import ./flake/hosts/zephyr.nix {
          user_name = "zephyr";
          inherit self inputs;
        };
      };

      nixosConfigurations = {
        wsl = import ./flake/hosts/wsl.nix {
          inherit inputs;
        };

        surface = import ./flake/hosts/surface.nix {
          inherit inputs;
        };

        saffron = import ./flake/hosts/saffron.nix {
          inherit inputs;
        };
      };
    };
  };
}
