{ pkgs, username, ... }:
{
  imports = [
    # cli
    ./programs/git
    ./programs/fastfetch
    ./programs/nixvim
    ./programs/nh
    ./programs/tree
    ./programs/btop
    ./programs/ghq
    ./programs/fzf
    ./programs/ripgrep
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
    ./programs/rea
    ./programs/ollama

    # gui
    ./programs/fuzzel
    ./programs/obs
    ./programs/ghostty
    ./programs/alacritty
    ./programs/noctalia
    ./programs/kitty
    ./programs/vesktop
    ./programs/vlc
    ./programs/kopuz
    ./programs/tigervnc
    ./programs/anki
    ./programs/google-chrome
    ./programs/firefox
    ./programs/zed-editor
    ./programs/vscodium
    ./programs/osu-lazer
    ./programs/prismlauncher
    ./programs/bedrock-on-linux
    ./programs/gimp
    ./programs/nautilus # GNOME file manager
    #./programs/lmstudio
    ./programs/signal-desktop
    ./programs/qtractor
    ./programs/lmms
    ./programs/kdenlive
    ./programs/copyq
    ./programs/effectcraft
    ./programs/zotero

    # utils
    ./programs/fontconfig
    ./programs/gtk
    ./programs/mako
    ./programs/udisk
    ./programs/dotfiles
    ./programs/slurp
    ./programs/nil # nix language server
    ./programs/gnumake
    ./programs/usbutils
    ./programs/easyeffect
    ./programs/pandoc
    ./programs/wayvr
    ./programs/w3m
    ./programs/souieba

    # wm
    ./programs/waybar
    ./programs/swayidle
    ./programs/swaylock
    ./programs/niri
    ./programs/swaybg
    ./programs/swayr

    # vm
    ./programs/docker
    ./programs/colima

    # saffron-specific
    ./programs/pipewire
    ./programs/wireplumber
    ./programs/playerctl
    ./programs/grim
    ./programs/xremap
    ./programs/brightnessctl
    ./programs/ddcutil
    ./programs/pavucontrol

    # tools
    ./tools/cursor
    ./tools/default-app
  ];

  home = {
    username = username;
    homeDirectory = "/home/${username}";
    stateVersion = "25.05";
    #packages = [ pkgs.buzz-desktop ];
  };
  programs.home-manager.enable = true;
}
