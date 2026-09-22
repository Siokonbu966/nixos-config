{ ignore_apps }:
[
  {
    name = "default";
    application = {
      not = ignore_apps;
    };
    remap = {
      Shift_L = "z";
      a = "e";
      w = "l";
      x = "c";
      e = "u";
      c = "v";
      r = "f";
      v = "Comma";
      g = "Minus";
      m = "g";
      i = "w";
      Comma = "d";
      o = "r";
      p = "y";
      Semicolon = "s";
      Apostrophe = "h";
      CapsLock = "q";
      Dot = "m";

      b = "Alt_R";
      n = "Ctrl_L";
      h = "Shift_L";
      t = "Kp0"; # +

      # left modifier keys
      f = "o";
      d = "a";
      s = "i";
     
      l = "n";
      k = "t";
      j = "k";

      # IME切り替え用
      Slash = {
        held = "Menu";
        alone = "j";
        free_hold = true;
      };
      z = {
        held = "Menu";
        alone = "x";
        free_hold = true;
      };

    };
  }

  {
    name = "JIS";
    device = {
      only = [
        "Keychron Keychron K2"
      ];
    };
    application = {
      not = ignore_apps;
    };
    remap = {
      RO = "b";
      Backslash = "p";
      Muhenkan = "Enter";

      # Layer用
      Space = {
        held = "Insert";
        alone = "Backspace";
        free_hold = true;
      };
      Henkan = {
        held = "ScrollLock";
        alone = "Space";
        free_hold = true;
      };
    };
  }

  {
    name = "US";
    device = {
      only = [
        "Keychron Keychron Receiver Keyboard"
        "Keychron B1 Pro Keyboard"
        "NuPhy NuPhy Air60 V2 Keyboard"
      ];
    };
    application = {
      not = ignore_apps;
    };
    remap = {
      Shift_R = "b";
      Enter = "p";

      # Layer用
      Space = {
        held = "Insert";
        alone = "Backspace";
        free_hold = true;
      };
      Alt_R = {
        held = "ScrollLock";
        alone = "Space";
        free_hold = true;
      };
      Alt_L = {
        held = "Alt_L";
        alone = "Enter";
        free_hold = true;
      };
    };
  }
]
