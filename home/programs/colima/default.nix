{ pkgs, ... }:
{
  # colima sets and activates its own Docker context ("colima") on start, so
  # DOCKER_HOST is intentionally not set here to avoid clobbering contexts.
  home.packages = [ pkgs.colima ];
}
