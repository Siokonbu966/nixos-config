{inputs, pkgs, ...}:
{
  programs.gh = {
    enable = true;
    package = inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.gh;
    settings = {
      editor = "nvim";
      git_protocol = "ssh";
      prompt = "enabled";
      spinner = "enabled";
    };
  };
}
