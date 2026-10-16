{ pkgs, username, ... }:

{
# Define a user account. Don't forget to set a password with 'passwd'.
  imports = [
  ];

  users.users.${username} = {
    isNormalUser = true;
    description = username;
    extraGroups = [
      "wheel"
    ];
    shell = pkgs.zsh;
    packages = with pkgs; [
    ];
  };

# Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  
  programs.zsh.enable = true;

# List packages installed in system profile. To search, run:
# $ nix search wget
  environment.systemPackages = with pkgs; [
    git
    vim
    firefox
#  wget
  ];

  nix = {
    settings = {
      experimental-features = ["nix-command" "flakes"];
    };
  };
}
