{ pkgs, inputs, ... }:
{
  home.packages = [
    inputs.late-sh.packages.${pkgs.system}.late
  ];
}