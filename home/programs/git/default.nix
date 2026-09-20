{ device, ...}: 
let
  device_config = if device == "zephyr" then {

  } else {
    signingkey = "~/.ssh/github.pub";
  };
in
{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Siokonbu966";
        email = "167207736+Siokonbu966@users.noreply.github.com";
      } // device_config;
      init = {
        defaultBranch = "main";
      };
      ghq = {
        root = "~/src";
      };
      gpg = {
        format = "ssh";
      };
      pull = {
        rebase = "true";
      };
      core.editor = "vi";
    };
  };

  home.file = {
    ".gitconfig".text = ''
      [includeIf "gitdir:~/src/crocus"]
        path = ~/.gitconfig-cro
      [user]
        name = "Siokonbu966"
        email = "167207736+Siokonbu966@users.noreply.github.com"
    '';
  };
}

