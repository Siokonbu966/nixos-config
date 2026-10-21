{config, lib, pkgs, ...}:
let
  ageKeyFile = "/var/lib/sops-nix/keys.txt";  # 鍵ファイルの場所(文字列)
  owner_name = if pkgs.stdenv.isDarwin then config.system.primaryUser else "root";
  group_name = if pkgs.stdenv.isDarwin then "staff" else "root";
in
{
  environment.systemPackages = [ pkgs.sops ];

  sops = {
    age.keyFile = ageKeyFile;  # 鍵ファイルの場所を指定
    age.generateKey = true;  # もし鍵ファイルが無ければ自動生成する
    defaultSopsFile = ../../secrets/example.yaml;
    defaultSopsFormat = "yaml";

    secrets = {
      samba_credentials = { 
        owner = owner_name;
        group = group_name;
        mode = "0400";
      };
      cachix_auth_token = {
        owner = owner_name;
        group = group_name;
        mode = "0400";
      };
      github_token = {
        owner = owner_name;
        group = group_name;
        mode = "0400";
      };
    };

    templates."nix-netrc" = {
      content = ''
        machine api.github.com
        password ${config.sops.placeholder.github_token}
      '';
      owner = owner_name;
      mode = "0400";
    };
  };

  nix.settings.netrc-file = config.sops.templates."nix-netrc".path;

  environment.variables = {
    SOPS_AGE_KEY_FILE = ageKeyFile;  # 鍵ファイルの場所を環境変数に
  };
}
