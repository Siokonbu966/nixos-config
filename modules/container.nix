{ ... }:
{
  # rootless podman (replaces colima on linux)
  virtualisation.podman = {
    enable = true;
    # resolve container names on the default bridge network
    defaultNetwork.settings.dns_enabled = true;
  };

  # `docker` CLI talks to the rootless podman socket, which is
  # $XDG_RUNTIME_DIR/podman/podman.sock == /run/user/1000/podman/podman.sock
  # (crocus is the first user, so uid 1000 on every host)
  environment.sessionVariables.DOCKER_HOST = "unix:///run/user/1000/podman/podman.sock";
}
