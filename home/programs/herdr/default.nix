{ pkgs, inputs, ... }:
{
  home.packages = [
    inputs.herdr.packages.${pkgs.system}.default
  ];

  xdg.configFile."herdr/config.toml".source = (pkgs.formats.toml { }).generate "config.toml" {
    onboarding = false;
    terminal = {
      default_shell = "zsh";
      new_cwd = "follow";
      shell_mode = "auto";
    };
    theme = {
      name = "kanagawa";
      dark_name = "kanagawa";
      custom = {
        panel_bg = "transparent";
      };
    };
    ui = {
      sidebar_width = 32;
      sound = {
        enabled = true;
      };
    };
    keys = {
      prefix = "ctrl+g";
    };
    experimental = {
      kitty_graphics = true;
    };
  };
}
