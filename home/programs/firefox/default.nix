{ pkgs, config, ... }:
let
  defaultProfile = "2gdsw1if.default";

  parfait = pkgs.fetchFromGitHub {
    owner = "reizumii";
    repo = "parfait";
    rev = "a21d3bca01b2bb0a971678ebae25cb809a69a6b7";
    hash = "sha256-dhxOAn0fSdZ0ipZoNzoyeA/HSt7Lt3jgu03MurFl33Q=";
  };
in
{
  programs.firefox = {
    enable = true;
    profiles = {
      default = {
        id = 0;
        path = defaultProfile;
        settings = {
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          "svg.context-properties.content.enabled" = true;

          "parfait.theme.borderless" = false;
          "parfait.theme.blur.enabled" = false;
          "parfait.theme.roundness.preset" = 0;

          "parfait.background.accent-color" = false;
          "parfait.background.accent-color.contrast" = 2;
          "parfait.background.accent-color.gradient" = false;
          "parfait.background.accent-color.opacity" = 4;
          "parfait.background.transparent" = false;

          "parfait.tabs.groups.fx-colors-on-folders" = false;

          "parfait.layout.unified-sidebar" = true;
          "parfait.layout.unified-sidebar.width.preset" = 2;

          "parfait.toolbar.sidebar-gutter" = true;

          "parfait.traffic-lights.enabled" = false;
          "parfait.traffic-lights.mono" = false;

          "parfait.urlbar.center-url" = false;

          "parfait.new-tab.logo.preset" = 1;
          "parfait.new-tab.background.pattern" = false;
        };
        userChrome = ''
          @import "parfait/parfait.css";
        '';
        userContent = ''
          @import "parfait/pages.css";
        '';
      };
      h = {
        id = 1;
        path = "qdkmkbh0.h";
      };
    };
  };

  home.file."${config.programs.firefox.profilesPath}/${defaultProfile}/chrome/parfait".source = "${parfait}/parfait";
}
