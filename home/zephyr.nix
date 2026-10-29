{ username, pkgs, ... }:
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
    ./programs/colima

    # cli
    ./programs/git
    ./programs/opencode
    #./programs/hermes-agent
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

  home = {
    username = username;
    homeDirectory = "/Users/${username}";
    stateVersion = "26.05";
  };
}
