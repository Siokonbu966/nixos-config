{ pkgs, username, ... }:
{
  imports = [
    # cli
    ./programs/git
    ./programs/fastfetch
    ./programs/nixvim
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
    ./programs/effectcraft
    ./programs/nb
    ./programs/wl-clipboard
    ./programs/late-sh
    ./programs/souieba
    ./programs/rea
    ./programs/colima

    # gui
    ./programs/fuzzel
    ./programs/obs
    ./programs/ghostty
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
    ./programs/nautilus
    #./programs/lmstudio
    ./programs/ollama
    ./programs/signal-desktop
    ./programs/qtractor
    ./programs/lmms
    ./programs/kdenlive
    ./programs/copyq

    # utils
    ./programs/fontconfig
    ./programs/gtk
    ./programs/mako
    ./programs/udisk
    ./programs/dotfiles
    ./programs/xsel
    ./programs/slurp
    ./programs/nil
    ./programs/gnumake
    ./programs/usbutils
    ./programs/easyeffect
    ./programs/pandoc
    ./programs/wayvr
    ./programs/w3m

    # wm
    ./programs/docker
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

  home = {
    username = username;
    homeDirectory = "/home/${username}";
    stateVersion = "25.05";
    packages = [ pkgs.buzz-desktop ];
  };
  programs.home-manager.enable = true;
}
