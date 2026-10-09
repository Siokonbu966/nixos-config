{ device, lib, pkgs, ... }:
let
  user = if device == "zephyr" then {
    name = "hoguhogu966";
    email = "302459077+hoguhogu966@users.noreply.github.com";
  } else {
    name = "Siokonbu966";
    email = "167207736+Siokonbu966@users.noreply.github.com";
  };
in
{
  programs.git = {
    enable = true;
    settings = {
      inherit user;
      init.defaultBranch = "main";
      ghq.root = "~/src";
      pull.rebase = "true";
      core.editor = "vi";
      wt.basedir = ".git/wt";
    };
    signing = {
      format = "ssh";
    } // lib.optionalAttrs (device != "zephyr") {
      key = "~/.ssh/github.pub";
    };
    includes = [
      {
        condition = "gitdir:~/src/crocus";
        path = "~/.gitconfig-cro";
      }
    ];
  };

  home.packages = [ pkgs.git-wt ];
}
