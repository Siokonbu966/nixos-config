{ lib, ...}:
let
  modifier = "mod4";
  menu = "fuzzel";
  terminal = "ghostty";
in
{
  wayland.windowManager.sway = {
    enable = true;
    checkConfig = false;
    xwayland = true;
    systemd.enable = true;
    config = {
      defaultWorkspace = "1";

      gaps = {
        inner = 6;
        outer = 3;
      };
      colors = {
        focused = {
          border = "#00ffff";
          background = "#2ca9e1";
          text = "#000000";
          indicator = "#2e9ef4";
          childBorder = "#2ca9e1";
        };
        # unfocused = {
        #   border = "#b0c4de";
        #   background = "#778899";
        #   text = "#ffffff";
        #   indicator = "#b0c4de";
        #   childBorder = "#285577";
        # };
      };
      bars = [
        {
          command = "waybar";
        }
      ];
      modifier = "${modifier}";
      keybindings = 
        lib.mkOptionDefault {
          "${modifier}+t" = "exec ${terminal}";
          "${modifier}+Shift+q" = "kill";
          "${modifier}+d" = "exec ${menu}";
          "${modifier}+Shift+p" = "exec systemctl suspend";
        };
      terminal = "${terminal}";
      menu = "${menu}";
      input = {
        "*" = {
          # reverse mouse scroll
          natural_scroll = "enabled";
        };
      };
    };
    extraConfig = ''
      # Volume
      bindsym XF86AudioRaiseVolume exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
      bindsym XF86AudioLowerVolume exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
      bindsym XF86AudioMute exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle

      # Media control
      bindsym XF86AudioPlay exec playerctl play-pause
      bindsym XF86AudioPause exec playerctl pause
      bindsym XF86AudioStop exec playerctl stop
      bindsym XF86AudioNext exec playerctl next
      bindsym XF86AudioPrev exec playerctl previous
      bindsym Print exec sh -c 'FILE=~/Pictures/screen_shots/$(date +%Y.%m.%d-%H:%M:%S).png; grim -g "$(slurp)" "$FILE" && notify-send "Screen shot saved" "$FILE"'
      bindsym Shift+Print exec sh -c 'FILE=~/Pictures/screen_shots/$(date +%Y.%m.%d-%H:%M:%S).png; grim  "$FILE" && notify-send "Screen shot saved" "$FILE"'

      exec_always fcitx5
      exec env RUST_BACKTRACE=1 RUST_LOG=swayr=debug swayrd > /tmp/swayrd.log 2>&1

      # bg
      output "*" background /home/crocus/Pictures/photo/wallpapers/splatoon_10th_02.jpg fill
      
      default_border pixel 4
      default_floating_border pixel 4
    '';
  };
}
