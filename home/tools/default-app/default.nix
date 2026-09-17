{ ... }:
{
  xdg.mimeApps = {
    enable = true;

    defaultApplications = {
      "x-scheme-handler/http" = ["firefox.desktop"];
      "x-scheme-handler/https" = ["firefox.desktop"];
      "text/html" = ["firefox.desktop"];
      "image/png" = "vlc.desktop";
      "image/jpg" = "vlc.desktop";
    };
  };
}
