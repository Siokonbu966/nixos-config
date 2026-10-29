{
  fetchFromGitHub,
  ollama,
}:
let
  version = "0.40.13-rc1";
  llamaCppVersion = "b11963";
in
ollama.overrideAttrs (oldAttrs: {
  inherit version;

  src = fetchFromGitHub {
    owner = "ollama";
    repo = "ollama";
    tag = "v${version}";
    hash = "sha256-cxpgG6l97S7f+XZy5Hb689MYpVnbaqxBhzHLL62zAKM=";
  };

  vendorHash = "sha256-1mzJrZUHH2ouP6I+LVojHbft7No5AumqKZVq0I/Ubsg=";

  passthru = oldAttrs.passthru // {
    inherit llamaCppVersion;
    llamaCppSrc = fetchFromGitHub {
      owner = "ggml-org";
      repo = "llama.cpp";
      tag = llamaCppVersion;
      hash = "sha256-DUggBODOVSOydWopvdXt/K9ZiRrbWrl+mywpr1vjJwM=";
    };
  };
})
