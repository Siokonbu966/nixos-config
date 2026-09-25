{ ignore_apps }:
[
  {
    name = "steam-mouse";
    application = {
      only = [ "steam_app_4274141638" ];
    };
    remap = {
      BTN_SIDE = "l";
      BTN_EXTRA = "m";
      # 7ボタンマウス等で BTN_BACK / BTN_FORWARD として認識される場合のフォールバック
      BTN_BACK = "l";
      BTN_FORWARD = "m";
    };
  }

  {
    name = "L1";
    application = {
      not = ignore_apps;
    };
    remap = {
      Insert-z = "SHIFT-4";  # $
      Insert-e = "0";
      Insert-x = "7";
      Insert-l = "1";
      Insert-i = "4";
      Insert-c = "8";
      Insert-u = "2";
      Insert-a = "5";
      Insert-v = "9";
      Insert-f = "3";
      Insert-o = "6";
      Insert-Comma = "Dot";  # .
      Insert-k = "Shift-6";    # ^
      Insert-g = "Shift-Minus"; # _
      Insert-w = "Shift-Comma";  # <
      Insert-t = "Shift-Equal";  # +
      Insert-d = "Shift-1";  # !
      Insert-r = "Equal";  # =
      Insert-n = "Minus";    # -
      Insert-m = "Shift-Slash";  # ?
      Insert-y = "Shift-dot";  # >
      Insert-s = "Kpasterisk";  # *
      Insert-j = "Shift-Semicolon";  # ;
      Insert-b = "Semicolon";   # :
      Insert-h = "Slash";   # /
      Insert-p = "Shift-5";  # %
      Insert-q = "Shift-Grave";  # ~
    };
  }

  {
    name = "L2";
    application = {
      not = ignore_apps;
    };
    remap = {
      ScrollLock-z = "BackSlash";  # ¥ \
      ScrollLock-e = "Shift-3";  # #
      ScrollLock-x = "Shift-LeftBrace";  # {
      ScrollLock-l = "LeftBrace";  # [
      ScrollLock-i = "Shift-9";  # (
      ScrollLock-c = "Grave";  # `
      ScrollLock-u = "Shift-Apostrophe";  # "
      ScrollLock-a = "Apostrophe";  # '
      ScrollLock-v = "Shift-RightBrace";  # }
      ScrollLock-f = "RightBrace";  # ]
      ScrollLock-o = "Shift-0";  # )
      ScrollLock-q = "Shift-2";  # @
      ScrollLock-Comma = "Shift-BackSlash";  # |
      ScrollLock-Minus = "Shift-7";  # &
      ScrollLock-k = "VolumeUp";
      ScrollLock-g = "VolumeDown";
      ScrollLock-w = "Esc";
      ScrollLock-t = "Left";
      ScrollLock-r = "Up";
      ScrollLock-n = "Down";
      ScrollLock-s = "Right";
      ScrollLock-j = "NextSong"; # 先送り (XF86AudioNext → playerctl next)
      ScrollLock-m = "StopCD"; # 停止 (XF86AudioStop → playerctl stop)
      ScrollLock-d = "PreviousSong"; # 一曲戻る (XF86AudioPrev → playerctl previous)
    };
  }

  {
    name = "other";
    application = {
      not = ignore_apps;
    };
    remap = {
      Kp0 = "Shift-Equal";
      Menu-c = "C-Space";     # IME us
      Menu-m = "C-BackSlash"; # IME jp
    };
  }
]
