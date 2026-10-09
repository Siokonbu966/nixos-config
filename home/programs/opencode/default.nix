{ inputs, pkgs, ... }:
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
in
{
  home.packages = [
    opencode
  ];

  xdg.configFile."opencode/opencode.json".source =
    (pkgs.formats.json { }).generate "opencode.json" {
      "$schema" = "https://opencode.ai/config.json";
      permission = {
        websearch = "allow";
        external_directory = {
          "*" = "allow";
          "/etc/**" = "ask";
          "/run/**" = "ask";
        };
        edit = {
          "*" = "allow";
          "/etc/**" = "deny";
          "/nix/**" = "deny";
          "/run/**" = "ask";
        };
        write = {
          "*" = "allow";
          "/etc/**" = "deny";
          "/nix/**" = "deny";
          "/run/**" = "deny";
        };
      };
      plugin = [
        "file://${inputs.i-have-adhd}/.opencode/plugins/i-have-adhd.mjs"
        "file://${./worktree-guard.ts}"
      ];
      skills.paths = [
        "${inputs.yomiyasu}/skills"
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
