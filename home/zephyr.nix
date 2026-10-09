{ user_name, pkgs, ... }:
{
  imports = [
    # common
    ./programs/nixvim
    ./programs/fastfetch
    ./programs/tree
    ./programs/btop
    ./programs/ghq
    ./programs/fzf
    ./programs/ripgrep
    ./programs/docker
    # ./programs/colima
    ./programs/podman

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
    # utils
    ./programs/nh
    ./programs/dotfiles

    # zephyr-specific
    ./programs/cloudflared
  ];

  home = rec {
    username = "${user_name}";
    homeDirectory = "/Users/${username}";
    stateVersion = "26.05";
  };
}
