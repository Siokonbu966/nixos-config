{ config, inputs, pkgs, ... }:
let
  opencode =
    inputs.opencode.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs
      (old: {
        nativeBuildInputs =
          (old.nativeBuildInputs or [])
          ++ pkgs.lib.optionals pkgs.stdenv.isDarwin [
            pkgs.darwin.sigtool
            pkgs.darwin.cctools
          ];
      });

  all_deniedPaths = [
    "~/.ssh/**"
    "~/.config/gh/**"
    "~/.config/sops/**"
    "~/.aws/**"
    "~/.azure/**"
    "~/.config/gcloud/**"
    "~/.config/gh/hosts.yml"
    "~/.git-credentials"
    "~/.netrc"
    ".env"
    ".env.*"
    "**/secrets/**"
    "**/*.pem"
    "**/*.key"
    "**/*.p12"
    "**/*.pfx"
    "**/credentials*"
    "**/*secret*"
    "**/*token*"
  ];

  deniedPermissions = builtins.listToAttrs (
    map (path: {
      name = path;
      value = "deny";
    }) all_deniedPaths
  );
  cssBestPracticesSkill = pkgs.runCommand "css-best-practices-skill" { } ''
    mkdir -p $out/css-best-practices
    cp ${inputs.css-best-practices}/skills/SKILL.md $out/css-best-practices/SKILL.md
  '';

  cssAnimationsSkill = pkgs.runCommand "css-animations-skill" { } ''
    mkdir -p $out/web-animation-css-animations
    cp -r ${inputs.css-animations}/dist/plugins/web-animation-css-animations/skills/web-animation-css-animations/. $out/web-animation-css-animations/
  '';
in
{
  home.packages = [
    opencode
  ];

  xdg.configFile."opencode/rules/commit-convention.md".source =
    ./rules/commit-convention.md;

  xdg.configFile."opencode/command/log.md".source = ./command/log.md;
  xdg.configFile."opencode/command/pr.md".source = ./command/pr.md;

  xdg.configFile."opencode/opencode.json".source =
    (pkgs.formats.json { }).generate "opencode.json" {
      "$schema" = "https://opencode.ai/config.json";
      instructions = [
        "${config.xdg.configHome}/opencode/rules/commit-convention.md"
      ];
      permission = {
        websearch = "allow";
        bash = {
          "git *" = "allow";
          "gh *" = "allow";
        };
        external_directory = {
          "*" = "allow";
        };
        edit = deniedPermissions // {
          "*" = "allow";
          "/etc/**" = "deny";
          "/nix/**" = "deny";
          "/run/**" = "ask";
          "~/.config/**" = "ask";
        };
        write = deniedPermissions // {
          "*" = "allow";
          "/etc/**" = "deny";
          "/nix/**" = "deny";
          "/run/**" = "deny";
          "~/.config/**" = "ask";
        };
        read = deniedPermissions // {
          "~/.config/**" = "ask";
        };
      };
      plugin = [
        "file://${inputs.i-have-adhd}/.opencode/plugins/i-have-adhd.mjs"
        "file://${./worktree-guard.ts}"
        "file://${./auto-commit.ts}"
      ];
      skills.paths = [
        "${inputs.yomiyasu}/skills"
        "${inputs.security-audit}/skills"
        "${./skills}"
        "${cssBestPracticesSkill}"
        "${cssAnimationsSkill}"
      ];
      mcp.context7 = {
        type = "remote";
        url = "https://mcp.context7.com/mcp";
        enabled = true;
      };
      agent = {
        teach = {
          description = "programming teacher to beginner";
          mode = "primary";
          prompt = "You are a programming instructor. Please generate a response in Japanese. The user is a beginner who has just learned the basics of programming, such as data types and operators. When using technical terms in your responses, please include a brief explanation. Keep your answers concise and address only what the user has asked.";
          tool = {
            "mymcp_*" = true;
          };
          permission = {
            edit = "deny";
            write = "deny";
            read = "allow";
            grep = "allow";
            glob = "allow";
            bash = "allow";
            webfetch = "allow";
            websearch = "allow";
          };
          color = "#ff7f50";
        };
      };
      provider = {
        lmstudio = {
          name = "LM Studio(local)";
          options.baseURL = "http://localhost:1234/v1";
          models = {
            "google/gemma-4-e4b".name = "gemma-4-e4b";
            "qwen3.5-9b".name = "qwen3.5-9b";
            "qwen3.5-9b-uncensored-hauhaucs-aggressive".name =
              "qwen3.5-9b-uncensored";
          };
        };
        ollama = {
          name = "ollama(local)";
          options.baseURL = "http://localhost:11434/v1";
          models = {
            "gemma4:e2b".name = "gemma-4-e4b";
            "qwen3.5:9b".name = "qwen3.5-9b";
          };
        };
      };
    };
}
