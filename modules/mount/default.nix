{...}:
{
  fileSystems."/mnt/share" = {
    device = "//192.168.0.96/share";
    fsType = "cifs";

    options = [
      "x-systemd.automount"
      "x-systemd.idle-timeout=600"
      "x-systemd.device-timeout=5s"
      "x-systemd.mount-timeout=10s"
      "_netdev"
      "nofail"
      "credentials=/run/secrets/samba_credentials"
      "uid=1000"
      "gid=100"
      "file_mode=0664"
      "dir_mode=0775"
    ];
  };
}
