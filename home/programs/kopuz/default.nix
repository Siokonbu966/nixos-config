{ pkgs, inputs, ... }:
{
  home.packages = [
    inputs.kopuz.packages.${pkgs.system}.default
  ];
}
