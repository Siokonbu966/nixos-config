{config, lib, pkgs, ...}:
let
  ageKeyFile = "/var/lib/sops-nix/keys.txt";  # 鍵ファイルの場所(文字列)
in
{
  sops = {
    age.keyFile = ageKeyFile;  # 鍵ファイルの場所を指定
    age.generateKey = true;  # もし鍵ファイルが無ければ自動生成する
    defaultSopsFile = ../../secrets/example.yaml;
    defaultSopsFormat = "yaml";

    secrets = {
      samba_credentials = { 
        owner = "root";
        group = "root";
        mode = "0400";
      };
      cachix_auth_token = {
        owner = "root";
        group = "root";
        mode = "0400";
      };
      siokon-nix-config-updater-secret = {
        owner = "root";
        group = "root";
        mode = "0400";
      };
    };
  };
  environment.variables = {
    SOPS_AGE_KEY_FILE = ageKeyFile;  # 鍵ファイルの場所を環境変数に
  };
}
