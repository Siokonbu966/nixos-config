{ ... }:

{
  plugins.lazygit = {
    enable = true;
    settings = {
      floating_window_winblend = 0;
      floating_window_scaling_factor = 0.9;
      floating_window_border_chars = [
        "╭"
        "─"
        "╮"
        "│"
        "╯"
        "─"
        "╰"
        "│"
      ];
    };
  };
}
