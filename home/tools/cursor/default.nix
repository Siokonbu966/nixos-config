{ pkgs, ... }:
{
  home.pointerCursor =
    let
      nordzy = pkgs.fetchzip {
        url = "https://github.com/guillaumeboehm/Nordzy-cursors/releases/download/v2.4.0/Nordzy-cursors.tar.gz";
        hash = "sha256-CM1trBf0TjmpyAtUwrhzxeBv5ZWRQ9bEiLlQsfOT3vE=";
      };
    in
    {
      gtk.enable = true;
      x11.enable = true;
      name = "Nordzy-cursors";
      package = pkgs.runCommand "nordzy-cursor" { } ''
        mkdir -p $out/share/icons
        ln -s ${nordzy} $out/share/icons/Nordzy-cursors
      '';
    };
}
