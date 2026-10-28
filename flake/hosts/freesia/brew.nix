{
  homebrew = {
    enable = true;
    casks = [
      "ghostty"
      "karabiner-elements"
      "discord"
      "slack"
      "google-chrome"
      "lm-studio"
      "tailscale-app"
      "appcleaner"
      "whatcable"
      "anki"
      "obs"
    ];
    onActivation = {
      autoUpdate = false;
    };
  };
}
