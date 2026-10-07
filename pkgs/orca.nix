{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpm_12,
  nodejs_24,
  python3,
  electron,
  makeWrapper,
  makeDesktopItem,
  jq,
  moreutils,
}:

let
  pnpm = pnpm_12;
  nodejs = nodejs_24;

  desktopItem = makeDesktopItem {
    name = "orca";
    desktopName = "Orca";
    comment = "ADE for working with a fleet of parallel agents";
    exec = "orca-ide %U";
    icon = "orca";
    categories = [
      "Development"
      "IDE"
    ];
    startupWMClass = "Orca";
    mimeTypes = [ "x-scheme-handler/orca" ];
    terminal = false;
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "orca";
  version = "1.4.222";

  src = fetchFromGitHub {
    owner = "stablyai";
    repo = "orca";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MXX24vkVNqoBKE99yR8bMPsKimD0WEhxVLLqvYcuBKk=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit pnpm;
    fetcherVersion = 3;
    hash = "sha256-P0QVXnkePynionO+1rkwNhiHs1tT76JDwtyzcd74FL4=";
  };

  nativeBuildInputs = [
    pnpmConfigHook
    pnpm
    nodejs
    python3
    makeWrapper
    jq
    moreutils
  ];

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
    npm_config_pm_on_fail = "ignore";
    pnpm_config_pm_on_fail = "ignore";
  };

  preBuild = ''
    export HOME=$TMPDIR
    export npm_config_nodedir=${electron.headers}
    export npm_config_runtime=electron
    export npm_config_target=${electron.version}
  '';

  buildPhase = ''
    runHook preBuild

    pnpm run build:relay
    pnpm run build:cli
    pnpm run build:electron-vite

    # Rebuild ABI-sensitive native addons against the Electron headers so the
    # main process can require them at runtime. `pnpm rebuild` would re-resolve
    # the whole graph (and try to hit the network), so call node-gyp directly.
    nodeptyDir=$(readlink -f node_modules/node-pty)
    (
      cd "$nodeptyDir"
      ${nodejs}/lib/node_modules/npm/node_modules/node-gyp/bin/node-gyp.js rebuild \
        --nodedir=${electron.headers} \
        --runtime=electron \
        --target=${electron.version}
    )

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/orca $out/bin
    cp -a package.json node_modules out resources $out/lib/orca/
    # `node_modules/@orca/windows-registry` is a pnpm workspace link into
    # `native/`; keep the target present so the link does not dangle.
    mkdir -p $out/lib/orca/native
    cp -a native/windows-registry $out/lib/orca/native/

    # The app is unpackaged, so @electron-toolkit/utils' `is.dev` is true and
    # Orca redirects its userData to `orca-dev`. The CLI, however, looks in
    # `orca` by default, so `orca open` would launch a GUI whose runtime the CLI
    # never finds and time out. Pin both wrappers to the same production-style
    # userData path so the CLI and the Electron app share runtime metadata.
    makeWrapper ${electron}/bin/electron $out/bin/orca-ide \
      --chdir "$out/lib/orca" \
      --add-flags "$out/lib/orca" \
      --set NODE_ENV production \
      --run 'export ORCA_DEV_USER_DATA_PATH="''${XDG_CONFIG_HOME:-$HOME/.config}/orca"' \
      --run 'export ORCA_USER_DATA_PATH="''${XDG_CONFIG_HOME:-$HOME/.config}/orca"'

    makeWrapper ${nodejs}/bin/node $out/bin/orca \
      --add-flags "$out/lib/orca/out/cli/index.js" \
      --set ORCA_APP_EXECUTABLE ${electron}/bin/electron \
      --set ORCA_APP_EXECUTABLE_NEEDS_APP_ROOT 1 \
      --run 'export ORCA_USER_DATA_PATH="''${XDG_CONFIG_HOME:-$HOME/.config}/orca"' \
      --run 'export ORCA_DEV_USER_DATA_PATH="''${XDG_CONFIG_HOME:-$HOME/.config}/orca"'

    install -Dm644 ${desktopItem}/share/applications/orca.desktop \
      $out/share/applications/orca.desktop
    install -Dm644 ${finalAttrs.src}/resources/build/icon.png \
      $out/share/icons/hicolor/512x512/apps/orca.png

    runHook postInstall
  '';

  doCheck = false;

  meta = with lib; {
    description = "ADE for working with a fleet of parallel agents";
    homepage = "https://github.com/stablyai/orca";
    license = licenses.mit;
    mainProgram = "orca-ide";
    platforms = platforms.linux;
  };
})
