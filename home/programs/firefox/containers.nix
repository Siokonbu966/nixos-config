{ lib }:
let
  schoolContainerId = 1;

  school = host: {
    inherit host;
    cookieStoreId = "firefox-container-${toString schoolContainerId}";
    containerName = "school";
    enabled = true;
  };
in
{
  containers = {
    school = {
      id = schoolContainerId;
      color = "orange";
      icon = "briefcase";
    };
  };
  containersForce = true;

  extensionSettings."containerise@kinte.sh" = {
    force = true;
    settings = lib.listToAttrs (
      map (host: lib.nameValuePair "map=${host}" (school host)) [
        "nlobby.nnn.ed.jp"
        "www.nnn.ed.nico"
        "app.slack.com"
      ]
    );
  };
}
