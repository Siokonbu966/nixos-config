{ lib, pkgs, device,...}: 
let
  device_config = if device == "zephyr" then {

  } else {
    signingkey = "~/.ssh/github.pub";
  };
in
{
  programs.git = {
    enable = true;
    ignores = [
      # Environment
      ".venv"
      ".direnv"

      # macOS
      ".DS_Store"
      ".AppleDouble"
      ".LSOverride"
      "Icon"
      "._*"
      ".DocumentRevisions-V100"
      ".fseventsd"
      ".Spotlight-V100"
      ".TemporaryItems"
      ".Trashes"
      ".VolumeIcon.icns"
      ".com.apple.timemachine.donotpresent"
      ".AppleDB"
      ".AppleDesktop"
      "Network Trash Folder"
      "Temporary Items"
      ".apdisk"

      # Python
      "__pycache__/"
      "*.py[cod]"
      "*$py.class"
      "*.so"
      ".Python"
      "build/"
      "develop-eggs/"
      "dist/"
      "downloads/"
      "eggs/"
      ".eggs/"
      "lib64/"
      "parts/"
      "sdist/"
      "var/"
      "wheels/"
      "pip-wheel-metadata/"
      "share/python-wheels/"
      "*.egg-info/"
      ".installed.cfg"
      "*.egg"
      "MANIFEST"
      "*.manifest"
      "*.spec"
      "pip-log.txt"
      "pip-delete-this-directory.txt"
      "htmlcov/"
      ".tox/"
      ".nox/"
      ".coverage"
      ".coverage.*"
      ".cache"
      "nosetests.xml"
      "coverage.xml"
      "*.cover"
      "*.py,cover"
      ".hypothesis/"
      ".pytest_cache/"
      "*.mo"
      "*.pot"
      "*.log"
      "local_settings.py"
      "db.sqlite3"
      "db.sqlite3-journal"
      "instance/"
      ".webassets-cache"
      ".scrapy"
      "docs/_build/"
      "target/"
      ".ipynb_checkpoints"
      "profile_default/"
      "ipython_config.py"
      ".python-version"
      "__pypackages__/"
      "celerybeat-schedule"
      "celerybeat.pid"
      "*.sage.py"
      ".env"
      "env/"
      "venv/"
      "ENV/"
      "env.bak/"
      "venv.bak/"
      ".spyderproject"
      ".spyproject"
      ".ropeproject"
      "/site"
      ".mypy_cache/"
      ".dmypy.json"
      "dmypy.json"
      ".pyre/"

      # Claude Code
      "**/.claude/settings.local.json"
      "**/CLAUDE.local.md"
      "z-ai/"

      # Continues
      ".continues-handoff.md"
    ];
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
      wt = {
        basedir = ".git/wt";
      };
      credential."https://github.com" = {
        helper = [
          ""
          "!${lib.getExe pkgs.ghtkn} git-credential"
        ];
        useHttpPath = true;
      };
    };
  };

  home.packages = [ pkgs.git-wt ];

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

