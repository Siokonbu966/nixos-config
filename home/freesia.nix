{ pkgs, ... }:
{
  imports = [
    ./programs/nixvim
    # common
    ./programs/fastfetch
    ./programs/tree
    ./programs/btop
    ./programs/ghq
    ./programs/fzf
    ./programs/ripgrep
    ./programs/w3m
    ./programs/docker
    ./programs/colima
    ./programs/ghostty/config.nix
    # cli
    ./programs/git
    ./programs/opencode
    ./programs/direnv
    ./programs/tmux
    ./programs/zsh
    ./programs/nushell
    ./programs/herdr
    ./programs/yazi
    ./programs/gh
    ./programs/emacs
    ./programs/ink
    ./programs/nb
    ./programs/late-sh
    # utils
    ./programs/nh
    ./programs/dotfiles
    # other
    ./programs/omniwm
    ./programs/R
  ];

  programs.omniwm = {
    enable = true;
    settings = {
      general = {
        updateChecksEnabled = false;
      };
    };
  };

  home = rec {
    username = "crocus";
    homeDirectory = "/Users/${username}";
    stateVersion = "26.05";
  };
}
