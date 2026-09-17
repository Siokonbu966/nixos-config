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
    # gui
    ./programs/fuzzel
    ./programs/obs
    ./programs/ghostty
    ./programs/noctalia
    ./programs/ollama
    # utils
    ./programs/gtk
    ./programs/mako
    ./programs/udisk
    ./programs/dotfiles
    ./programs/default-app
    ./programs/nh
    ./programs/xsel
    # wm
    ./programs/waybar
    ./programs/swayidle
    ./programs/swaylock
    ./programs/niri
    # saffron-specific
    ./programs/kitty
    ./programs/slurp
    ./programs/nil
    ./programs/gnumake
    ./programs/usbutils
    ./programs/pipewire
    ./programs/wireplumber
    ./programs/grim
    ./programs/wl-clipboard
    ./programs/xremap
    ./programs/brightnessctl
    ./programs/ddcutil
    ./programs/obsidian
    ./programs/vesktop
    ./programs/slack
    ./programs/pavucontrol
    ./programs/tigervnc
    ./programs/falkon
    ./programs/vlc
    ./programs/anki
    ./programs/google-chrome
    ./programs/zed-editor
    ./programs/vscodium
    ./programs/osu-lazer
    ./programs/prismlauncher
    ./programs/gimp
    ./programs/nautilus
    ./programs/lmstudio
    ./programs/signal-desktop
    ./programs/qtractor
    ./programs/lmms
    ./programs/kdenlive
    ./programs/nb
    ./programs/swaybg
    ./programs/swayr
    ./programs/wofi
    ./programs/alacritty

    # tools
    ./tools/cursor
  ];

  home = rec {
    username = "crocus";
    homeDirectory = "/home/${username}";
    stateVersion = "25.05";
    packages = [ pkgs.buzz-desktop ];
  };
  programs.home-manager.enable = true;
}
