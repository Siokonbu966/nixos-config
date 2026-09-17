[
  {
    name = "default";
    remap = {
      Shift_L = "z";
      a = "e";
      w = "l";
      s = "i";
      x = "c";
      e = "u";
      d = "a";
      c = "v";
      r = "f";
      f = "o";
      v = "Comma";
      g = "Minus";
      j = "k";
      m = "g";
      i = "w";
      k = "t";
      Comma = "d";
      o = "r";
      p = "y";
      l = "n";
      Semicolon = "s";
      Apostrophe = "h";
      CapsLock = "q";
      Dot = "m";
     
      b = "Alt_R";
      n = "Ctrl_L";
      h = "Shift_L";
      t = "Kp0"; # +

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
        hold = "Alt_L";
        alone = "Enter";
        free_hold = true;
      };
    };
  }
]
