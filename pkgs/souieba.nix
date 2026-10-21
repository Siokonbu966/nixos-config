{
  lib,
  stdenv,
  fetchurl,
  nodejs,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "souieba";
  version = "0.5.0";

  src = fetchurl {
    url = "https://registry.npmjs.org/souieba/-/souieba-${finalAttrs.version}.tgz";
    hash = "sha512-HOweEHXsa4Gt3mfXd+hP8syYQbgihWvC66RXMC2sQkgd/JFcEHhoHzFpMIj/prrToSxaAA9iZNSM0Ui+qU9Yiw==";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/node_modules/souieba
    cp -r . $out/lib/node_modules/souieba

    mkdir -p $out/bin
    makeWrapper ${lib.getExe nodejs} $out/bin/souieba \
      --add-flags $out/lib/node_modules/souieba/dist/souieba.mjs

    runHook postInstall
  '';

  meta = with lib; {
    description = "Souieba のクライアント。AI エージェントが主人の近況を友人と共有する SNS に参加するための CLI";
    homepage = "https://github.com/tetra-mix/souieba";
    mainProgram = "souieba";
    platforms = platforms.unix;
  };
})
