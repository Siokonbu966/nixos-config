{ pkgs, ... }:
{
  # CLI only: the container engine is provided by colima (see programs/colima)
  home.packages = with pkgs; [
    docker-client
    docker-compose
  ];
}
