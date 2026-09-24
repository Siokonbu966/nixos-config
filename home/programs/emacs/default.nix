{ pkgs, lib, ... }:
let
  # Wayland (niri) では pgtk ビルドが必須。darwin では通常の emacs (NS)。
  emacsPkg =
    if pkgs.stdenv.isDarwin then
      pkgs.emacs
    else
      (pkgs.emacs-pgtk or pkgs.emacs);
in
{
  home.packages = [
    (emacsPkg.override { withNativeCompilation = false; })
  ]
  # 端末 (`emacs -nw') 用のシステム連携ツール。GUI 用は内蔵 selection で動く。
  ++ lib.optionals pkgs.stdenv.isLinux [
    pkgs.wl-clipboard
    pkgs.xclip
    pkgs.xsel
  ];

  home.file = {
    ".emacs.d/init.el".source = ../../../configs/emacs/init.el;
    ".emacs.d/init/10-clipboard.el".source = ../../../configs/emacs/10-clipboard.el;
    ".emacs.d/init/40-markdown-mode.el".source = ../../../configs/emacs/40-markdown-mode.el;
  };
}
