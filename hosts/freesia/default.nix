{ self, pkgs, inputs, ... }:
{
  imports = [
    ./brew.nix
    ../../modules/font.nix
    ../../modules/netrc.nix
    ../../modules/cachix
  ];

  environment.systemPackages = with pkgs; [
    vim
  ];
  
  nix.settings.experimental-features = "nix-command flakes";

  # Set Git commit hash for darwin-version.
  system.configurationRevision = self.rev or self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
  system.primaryUser = "crocus";
  nixpkgs.config.allowUnfree = true;

  security.pam.services.sudo_local = {
    touchIdAuth = true;
    reattach = true;
  };
  
  users.users.crocus = {
    name = "crocus";
    home = "/Users/crocus";
  };
}
