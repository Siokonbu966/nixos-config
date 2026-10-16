{ username, ... }:
{
  programs.swaylock = {
    enable = true;

    settings = {
      ########################################
      # Background
      ########################################

      color = "1e1e2e";

      image = "/home/${username}/Pictures/Wallpapers/white_raftgirl.jpg";
      scaling = "fill";

      ########################################
      # Clock
      ########################################

      # clock = true;

      # timestr = "%H:%M";
      # datestr = "%Y-%m-%d";

      ########################################
      # Font
      ########################################

      font = "Mononoki Nerd Font";
      font-size = 24;

      ########################################
      # Indicator
      ########################################

      indicator = true;

      indicator-radius = 120;
      indicator-thickness = 10;

      ########################################
      # Colors
      ########################################

      inside-color = "313244cc";
      inside-clear-color = "f9e2afcc";
      inside-ver-color = "a6e3a1cc";
      inside-wrong-color = "f38ba8cc";

      ring-color = "89b4faff";
      ring-clear-color = "f9e2afff";
      ring-ver-color = "a6e3a1ff";
      ring-wrong-color = "f38ba8ff";

      line-color = "00000000";
      separator-color = "00000000";

      text-color = "cdd6f4ff";
      text-clear-color = "1e1e2eff";
      text-ver-color = "1e1e2eff";
      text-wrong-color = "1e1e2eff";

      key-hl-color = "a6e3a1ff";
      bs-hl-color = "f38ba8ff";

      ########################################
      # Behavior
      ########################################

      show-failed-attempts = true;

      # fade-in = 0.2;
      # grace = 2;
      daemonize = true;
    };
  };
}
