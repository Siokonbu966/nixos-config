{
  homebrew = {
    enable = true;
    casks = [
      "lm-studio"
      "tailscale-app"
      "appcleaner"
    ];
    onActivation = {
      autoUpdate = false;
    };
  };
}
