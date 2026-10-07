{ pkgs, ... }:
{
  home.packages = [ pkgs.ghtkn ];

  xdg.configFile."ghtkn/ghtkn.yaml".text = ''
    apps:
      - name: default
        client_id: Iv23liha7eS8tYewZBow
        git_owner: Siokonbu966
  '';
}
