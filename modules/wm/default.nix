{ config, username, ... }:
{
  imports = [
    ./niri.nix
    ./noctalia.nix
    # ./sway.nix
];

  environment.sessionVariables = {
  WLR_NO_HARDWARE_CURSORS = "1";
  NIXOS_OZONE_WL = "1";
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${config.programs.niri.package}/bin/niri-session";
        user = username;
      };
    };
  };

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver = {
    enable = true;
  #  exportConfiguration = true;
  #  displayManager.lightdm.enable = true;

    # Enable the LXQt Desktop Environment.
    # desktopManager.lxqt.enable = true;
  };

  # Enable the KDE Plasma Desktop Environment.
  # services.displayManager.sddm.enable = true;
  # services.desktopManager.plasma6.enable = true;

  # enable hyperland
  #programs.hyprland = {
  # enable = true;
  # xwayland.enable = true;
  # withUWSM = true;
  #};


  #xdg.portal = {
  #  enable = true;
  #  extraPortals = [
  #    pkgs.xdg-desktop-portal-hyprland
  #    pkgs.xdg-desktop-portal-gtk
  #  ];
  #  config = {
  #    common = {
  #      default = [ "gtk" ];
  #    };
  #    hyprland = {
  #      default = [ "hyprland" "gtk" ];
  #    };
  #  };
  #};
}
