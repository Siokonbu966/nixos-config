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
    ./programs/fontconfig
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
    ./programs/glow
    ./programs/ink
    ./programs/nb
    ./programs/wl-clipboard
    ./programs/late-sh

    # gui
    ./programs/fuzzel
    ./programs/obs
    ./programs/ghostty
    ./programs/noctalia
    ./programs/kitty
    ./programs/vesktop
    ./programs/vlc
    ./programs/tigervnc
    ./programs/anki
    ./programs/google-chrome
    ./programs/zed-editor
    ./programs/vscodium
    ./programs/osu-lazer
    ./programs/prismlauncher
    ./programs/bedrock-on-linux
    ./programs/gimp
    ./programs/nautilus
    #./programs/lmstudio
    ./programs/ollama
    ./programs/signal-desktop
    ./programs/qtractor
    ./programs/lmms
    ./programs/kdenlive
    ./programs/copyq

    # utils
    ./programs/gtk
    ./programs/mako
    ./programs/udisk
    ./programs/dotfiles
    ./programs/nh
    ./programs/xsel
    ./programs/slurp
    ./programs/nil
    ./programs/gnumake
    ./programs/usbutils
    ./programs/easyeffect

    # wm
    ./programs/waybar
    ./programs/swayidle
    ./programs/swaylock
    ./programs/niri
    ./programs/swaybg
    ./programs/swayr

    # saffron-specific
    ./programs/pipewire
    ./programs/wireplumber
    ./programs/playerctl
    ./programs/grim
    ./programs/xremap
    ./programs/brightnessctl
    ./programs/ddcutil
    ./programs/pavucontrol
    ./programs/alacritty

    # tools
    ./tools/cursor
    ./tools/default-app
  ];

  home = rec {
    username = "crocus";
    homeDirectory = "/home/${username}";
    stateVersion = "25.05";
    packages = [ pkgs.buzz-desktop ];
  };
  programs.home-manager.enable = true;
}
