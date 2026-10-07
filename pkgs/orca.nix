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
  gtk3,
  gtk4,
  gsettings-desktop-schemas,
  librsvg,
  dconf,
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

    # Electron's dist becomes the packaged app root. The binary name is
    # load-bearing: a binary literally named "electron" is treated as the dev
    # shell, so app.isPackaged is false and Orca installs a dev-parent watchdog
    # that quits the window as soon as `orca open` (its parent) exits. Naming it
    # `orca-ide` flips app.isPackaged to true and disables that watchdog.
    cp -a ${electron.dist}/. $out/lib/orca/
    chmod -R u+w $out/lib/orca
    mv $out/lib/orca/electron $out/lib/orca/orca-ide
    rm -f $out/lib/orca/resources/default_app.asar

    # The application code lives in resources/app, which Electron loads as a
    # packaged app when no path argument is passed.
    mkdir -p $out/lib/orca/resources/app
    cp -a package.json out node_modules native $out/lib/orca/resources/app/

    # Runtime assets the packaged app reads from process.resourcesPath.
    cp -a resources/. $out/lib/orca/resources/
    cp -a out/relay $out/lib/orca/resources/relay
    mkdir -p $out/lib/orca/resources/ripgrep
    cp -a node_modules/@vscode/ripgrep-universal/bin/. $out/lib/orca/resources/ripgrep/

    # Some modules resolve deps as resourcesPath/{app.asar,app.asar.unpacked}/...
    # and others as resourcesPath/node_modules/...; point all of those at the
    # single app tree so both styles resolve.
    ln -s app $out/lib/orca/resources/app.asar
    ln -s app $out/lib/orca/resources/app.asar.unpacked
    ln -s app/node_modules $out/lib/orca/resources/node_modules

    makeWrapper $out/lib/orca/orca-ide $out/bin/orca-ide \
      --set NODE_ENV production \
      --set CHROME_DEVEL_SANDBOX "$out/lib/orca/chrome-sandbox" \
      --prefix GIO_EXTRA_MODULES : "${dconf.lib}/lib/gio/modules" \
      --set GDK_PIXBUF_MODULE_FILE "${librsvg}/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache" \
      --prefix XDG_DATA_DIRS : "${gtk3}/share/gsettings-schemas/${gtk3.name}:${gtk4}/share/gsettings-schemas/${gtk4.name}:${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}"

    # The CLI runs inside Electron's Node mode, exactly like the upstream
    # launcher, so `orca open`/`orca serve` can re-exec the app. It must carry
    # the same Chromium/GTK environment as the GUI wrapper because the child it
    # spawns is the raw `orca-ide` binary, not this wrapper (without
    # CHROME_DEVEL_SANDBOX the spawned app dies with SIGILL).
    makeWrapper $out/lib/orca/orca-ide $out/bin/orca \
      --set ELECTRON_RUN_AS_NODE 1 \
      --set NODE_ENV production \
      --set CHROME_DEVEL_SANDBOX "$out/lib/orca/chrome-sandbox" \
      --prefix GIO_EXTRA_MODULES : "${dconf.lib}/lib/gio/modules" \
      --set GDK_PIXBUF_MODULE_FILE "${librsvg}/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache" \
      --prefix XDG_DATA_DIRS : "${gtk3}/share/gsettings-schemas/${gtk3.name}:${gtk4}/share/gsettings-schemas/${gtk4.name}:${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}" \
      --add-flags "$out/lib/orca/resources/app/out/cli/index.js"

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
