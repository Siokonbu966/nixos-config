{
  lib,
  buildGoModule,
  fetchFromGitHub,
  go_1_27,
}:

buildGoModule.override { go = go_1_27; } (finalAttrs: {
  pname = "ghtkn";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "suzuki-shunsuke";
    repo = "ghtkn";
    rev = "v${finalAttrs.version}";
    hash = "sha256-EtILxa6d6kmsd/6DykGqfokc3rrsXzf7ciettCkgo5E=";
  };

  vendorHash = "sha256-oA9US4CoGZrkhyVCiDooV5PkTV9akDUtcSqguc+4sEk=";

  subPackages = [ "cmd/ghtkn" ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=v${finalAttrs.version}"
  ];

  meta = with lib; {
    description = "A CLI to create short-lived GitHub App User Access Tokens for secure local development";
    homepage = "https://github.com/suzuki-shunsuke/ghtkn";
    license = licenses.mit;
    mainProgram = "ghtkn";
    platforms = platforms.linux ++ platforms.darwin;
  };
})
