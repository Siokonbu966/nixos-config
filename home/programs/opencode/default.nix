{ inputs, pkgs, ... }:
{
  home.packages = [
    inputs.opencode.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  xdg.configFile."opencode/opencode.json".source =
    (pkgs.formats.json { }).generate "opencode.json" {
      "$schema" = "https://opencode.ai/config.json";
      permission.websearch = "allow";
      mcp.context7 = {
        type = "remote";
        url = "https://mcp.context7.com/mcp";
        enabled = true;
      };
      provider = {
        lmstudio = {
          name = "LM Studio(local)";
          options.baseURL = "http://localhost:1234/v1";
          models = {
            "google/gemma-4-e4b".name = "google-gemma-4-e4b";
            "qwen3.5-9b".name = "qwen3.5-9b";
            "qwen3.5-9b-uncensored-hauhaucs-aggressive".name =
              "qwen3.5-9b-uncensored";
          };
        };
        ollama = {
          name = "ollama(local)";
          options.baseURL = "http://localhost:11434/v1";
          models = {
            "google/gemma-4-e2b".name = "google-gemma-4-e4b";
            "qwen3.5-9b".name = "qwen3.5-9b";
          };
        };
      };
    };
}
