{ pkgs, username, ... }:
{
  imports = [
    # gui
    ./programs/ghostty/config.nix
    ./programs/vesktop
    ./programs/effectcraft
    ./programs/kopuz

    # cli
    ./programs/git
    ./programs/nixvim
    ./programs/opencode
    ./programs/tmux
    ./programs/zsh
    ./programs/nushell
    ./programs/herdr
    ./programs/yazi
    ./programs/gh
    ./programs/fastfetch
    ./programs/tree
    ./programs/btop
    ./programs/ghq
    ./programs/fzf
    ./programs/ripgrep
    ./programs/emacs
    ./programs/ink
    ./programs/nb
    ./programs/late-sh
    ./programs/rea
    ./programs/ollama
    ./programs/glow
    ./programs/R

    # utils
    ./programs/nh
    ./programs/direnv
    ./programs/w3m
    ./programs/dotfiles
    ./programs/souieba

    # vm
    ./programs/docker
    ./programs/colima
    
    # wm
    ./programs/omniwm
  ];

  programs.omniwm = {
    enable = true;
    settings = {
      general = {
        updateChecksEnabled = false;
      };
    };
  };

  home = {
    username = username;
    homeDirectory = "/Users/${username}";
    stateVersion = "26.05";
  };
}
