{ pkgs, inputs, ... }:
{
  home.packages = [
    inputs.bedrock-on-linux.packages.${pkgs.system}.default
  ];
}
