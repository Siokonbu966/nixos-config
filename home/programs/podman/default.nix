{ pkgs, ... }:
{
  # podman itself is installed system wide (see modules/container.nix)
  # DOCKER_HOST is set there too, so these clients use the rootless socket
  home.packages = with pkgs; [
    docker-client
    docker-compose
  ];
}
