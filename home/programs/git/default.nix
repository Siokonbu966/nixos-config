{ device, lib, pkgs, ... }:
{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Siokonbu966";
        email = "167207736+Siokonbu966@users.noreply.github.com";
      };
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
