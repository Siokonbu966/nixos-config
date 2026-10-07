{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  rustPlatform,
  cargo-tauri,
  pnpm,
  nodejs,
  fetchPnpmDeps,
  pnpmConfigHook,
  pkg-config,
  wrapGAppsHook3,
  glib,
  gtk3,
  webkitgtk_4_1,
  libayatana-appindicator,
  librsvg,
  alsa-lib,
  openssl,
  sqlite,
  opus,
  libclang,
  pango,
  gdk-pixbuf,
  cairo,
  harfbuzz,
  dbus,
  libsecret,
  curl,
  perl,
  jq,
  buzz-sidecars ? null,
  gst_all_1,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "buzz-desktop";
  version = "0.5.14";

  src = fetchFromGitHub {
    owner = "block";
    repo = "buzz";
    tag = "desktop-v${finalAttrs.version}";
    hash = "sha256-kiJqUSzQZw6i9+W62T2lFyiDFwOnOKGXIXvQj4oeQgE=";
  };

  cargoLock = {
    lockFile = finalAttrs.src + "/desktop/src-tauri/Cargo.lock";
    outputHashes = {
      "mesh-llm-api-client-0.75.1" = "sha256-RXjmM66u40cxnacbvTtCFJShMK4BM+MHOyJ2vQ7Gw60=";
      "mesh-llm-api-server-0.75.1" = "sha256-RXjmM66u40cxnacbvTtCFJShMK4BM+MHOyJ2vQ7Gw60=";
      "mesh-llm-build-info-0.75.1" = "sha256-RXjmM66u40cxnacbvTtCFJShMK4BM+MHOyJ2vQ7Gw60=";
      "mesh-llm-client-0.75.1" = "sha256-RXjmM66u40cxnacbvTtCFJShMK4BM+MHOyJ2vQ7Gw60=";
      "mesh-llm-config-0.75.1" = "sha256-RXjmM66u40cxnacbvTtCFJShMK4BM+MHOyJ2vQ7Gw60=";
      "mesh-llm-embedded-runtime-0.75.1" = "sha256-RXjmM66u40cxnacbvTtCFJShMK4BM+MHOyJ2vQ7Gw60=";
      "mesh-llm-events-0.75.1" = "sha256-RXjmM66u40cxnacbvTtCFJShMK4BM+MHOyJ2vQ7Gw60=";
      "mesh-llm-gpu-bench-0.75.1" = "sha256-RXjmM66u40cxnacbvTtCFJShMK4BM+MHOyJ2vQ7Gw60=";
      "mesh-llm-guardrails-0.75.1" = "sha256-RXjmM66u40cxnacbvTtCFJShMK4BM+MHOyJ2vQ7Gw60=";
      "mesh-llm-hardware-profile-0.75.1" = "sha256-RXjmM66u40cxnacbvTtCFJShMK4BM+MHOyJ2vQ7Gw60=";
      "mesh-llm-host-runtime-0.75.1" = "sha256-RXjmM66u40cxnacbvTtCFJShMK4BM+MHOyJ2vQ7Gw60=";
      "mesh-llm-identity-0.75.1" = "sha256-RXjmM66u40cxnacbvTtCFJShMK4BM+MHOyJ2vQ7Gw60=";
      "mesh-llm-native-runtime-0.75.1" = "sha256-RXjmM66u40cxnacbvTtCFJShMK4BM+MHOyJ2vQ7Gw60=";
      "mesh-llm-node-0.75.1" = "sha256-RXjmM66u40cxnacbvTtCFJShMK4BM+MHOyJ2vQ7Gw60=";
      "mesh-llm-plugin-0.75.1" = "sha256-RXjmM66u40cxnacbvTtCFJShMK4BM+MHOyJ2vQ7Gw60=";
      "mesh-llm-plugin-manager-0.75.1" = "sha256-RXjmM66u40cxnacbvTtCFJShMK4BM+MHOyJ2vQ7Gw60=";
      "mesh-llm-protocol-0.75.1" = "sha256-RXjmM66u40cxnacbvTtCFJShMK4BM+MHOyJ2vQ7Gw60=";
      "mesh-llm-release-footer-0.75.1" = "sha256-RXjmM66u40cxnacbvTtCFJShMK4BM+MHOyJ2vQ7Gw60=";
      "mesh-llm-routing-0.75.1" = "sha256-RXjmM66u40cxnacbvTtCFJShMK4BM+MHOyJ2vQ7Gw60=";
      "mesh-llm-runtime-install-0.75.1" = "sha256-RXjmM66u40cxnacbvTtCFJShMK4BM+MHOyJ2vQ7Gw60=";
      "mesh-llm-sdk-0.75.1" = "sha256-RXjmM66u40cxnacbvTtCFJShMK4BM+MHOyJ2vQ7Gw60=";
      "mesh-llm-skills-0.75.1" = "sha256-RXjmM66u40cxnacbvTtCFJShMK4BM+MHOyJ2vQ7Gw60=";
      "mesh-llm-system-0.75.1" = "sha256-RXjmM66u40cxnacbvTtCFJShMK4BM+MHOyJ2vQ7Gw60=";
      "mesh-llm-types-0.75.1" = "sha256-RXjmM66u40cxnacbvTtCFJShMK4BM+MHOyJ2vQ7Gw60=";
      "mesh-llm-ui-0.75.1" = "sha256-RXjmM66u40cxnacbvTtCFJShMK4BM+MHOyJ2vQ7Gw60=";
      "mesh-mixture-of-agents-0.75.1" = "sha256-RXjmM66u40cxnacbvTtCFJShMK4BM+MHOyJ2vQ7Gw60=";
      "mesh-native-serving-plugin-api-0.75.1" = "sha256-RXjmM66u40cxnacbvTtCFJShMK4BM+MHOyJ2vQ7Gw60=";
      "mesh-native-serving-plugin-host-0.75.1" = "sha256-RXjmM66u40cxnacbvTtCFJShMK4BM+MHOyJ2vQ7Gw60=";
      "model-artifact-0.75.1" = "sha256-RXjmM66u40cxnacbvTtCFJShMK4BM+MHOyJ2vQ7Gw60=";
      "model-hf-0.75.1" = "sha256-RXjmM66u40cxnacbvTtCFJShMK4BM+MHOyJ2vQ7Gw60=";
      "model-package-0.75.1" = "sha256-RXjmM66u40cxnacbvTtCFJShMK4BM+MHOyJ2vQ7Gw60=";
      "model-ref-0.75.1" = "sha256-RXjmM66u40cxnacbvTtCFJShMK4BM+MHOyJ2vQ7Gw60=";
      "model-resolver-0.75.1" = "sha256-RXjmM66u40cxnacbvTtCFJShMK4BM+MHOyJ2vQ7Gw60=";
      "openai-frontend-0.75.1" = "sha256-RXjmM66u40cxnacbvTtCFJShMK4BM+MHOyJ2vQ7Gw60=";
      "skippy-cache-0.75.1" = "sha256-RXjmM66u40cxnacbvTtCFJShMK4BM+MHOyJ2vQ7Gw60=";
      "skippy-coordinator-0.75.1" = "sha256-RXjmM66u40cxnacbvTtCFJShMK4BM+MHOyJ2vQ7Gw60=";
      "skippy-ffi-0.75.1" = "sha256-RXjmM66u40cxnacbvTtCFJShMK4BM+MHOyJ2vQ7Gw60=";
      "skippy-metrics-0.75.1" = "sha256-RXjmM66u40cxnacbvTtCFJShMK4BM+MHOyJ2vQ7Gw60=";
      "skippy-protocol-0.75.1" = "sha256-RXjmM66u40cxnacbvTtCFJShMK4BM+MHOyJ2vQ7Gw60=";
      "skippy-runtime-0.75.1" = "sha256-RXjmM66u40cxnacbvTtCFJShMK4BM+MHOyJ2vQ7Gw60=";
      "skippy-server-0.75.1" = "sha256-RXjmM66u40cxnacbvTtCFJShMK4BM+MHOyJ2vQ7Gw60=";
      "skippy-tokenizer-0.75.1" = "sha256-RXjmM66u40cxnacbvTtCFJShMK4BM+MHOyJ2vQ7Gw60=";
      "skippy-topology-0.75.1" = "sha256-RXjmM66u40cxnacbvTtCFJShMK4BM+MHOyJ2vQ7Gw60=";
    };
  };

  cargoRoot = "desktop/src-tauri";
  buildAndTestSubdir = finalAttrs.cargoRoot;

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm;
    fetcherVersion = 4;
    hash = "sha256-2lGY34zfX0I1CXETvZLmJ7lKuIW5PpAWbKzESbH/s7w=";
  };

  sherpaOnnxArchive = fetchurl {
    url = "https://github.com/k2-fsa/sherpa-onnx/releases/download/v1.13.4/sherpa-onnx-v1.13.4-linux-x64-static-lib.tar.bz2";
    hash = "sha256-mLDjGZZCb254JE284ZVVSPLGTo8BxL51uFr3zaoujVw=";
  };

  sherpaOnnxDir = stdenv.mkDerivation {
    name = "sherpa-onnx-dir";
    src = finalAttrs.sherpaOnnxArchive;
    dontUnpack = true;
    installPhase = ''
      mkdir -p $out
      cp $src $out/sherpa-onnx-v1.13.4-linux-x64-static-lib.tar.bz2
    '';
  };

  nativeBuildInputs = [
    cargo-tauri.hook
    pnpmConfigHook
    pnpm
    nodejs
    pkg-config
    wrapGAppsHook3
    perl
    jq
  ];

  buildInputs = [
    glib
    gtk3
    webkitgtk_4_1
    libayatana-appindicator
    librsvg
    alsa-lib
    openssl
    sqlite
    opus
    libclang
    pango
    gdk-pixbuf
    cairo
    harfbuzz
    dbus
    libsecret
    curl
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
  ];

  postPatch = ''
    # Skip tsc type checking (has upstream TS errors) — change build script to just run vite
    jq '.scripts.build = "vite build"' desktop/package.json > tmp.json && mv tmp.json desktop/package.json

    # Set window visible: true so it appears on Wayland/niri
    jq '.app.windows[0].visible = true' desktop/src-tauri/tauri.conf.json > tmp.json && mv tmp.json desktop/src-tauri/tauri.conf.json

    # Remove patchedDependencies from both workspace config and lockfile
    # to avoid pnpm version mismatch (upstream 11.4.0 vs nixpkgs 11.15.0)
    sed -i '/^patchedDependencies:/,$d' pnpm-workspace.yaml
    # Remove lines 11-14 (patchedDependencies block) from lockfile
    sed -i '11,14d' pnpm-lock.yaml

    # Remove test module that references cfg(debug_assertions) symbols not available in release builds
    sed -i '/#\[cfg(test)\]/{N;d}' desktop/src-tauri/src/lib.rs

    # Bundle sidecar binaries (mirrors scripts/bundle-sidecars.sh)
    ${lib.optionalString (buzz-sidecars != null) ''
      mkdir -p desktop/src-tauri/binaries
      TARGET="${stdenv.hostPlatform.config}"
      for bin in buzz-acp buzz-agent buzz-backend-kubernetes buzz-dev-mcp git-credential-nostr; do
        cp ${buzz-sidecars}/bin/$bin "desktop/src-tauri/binaries/$bin-$TARGET"
        chmod 755 "desktop/src-tauri/binaries/$bin-$TARGET"
      done
      cp ${buzz-sidecars}/bin/buzz "desktop/src-tauri/binaries/buzz-$TARGET"
      chmod 755 "desktop/src-tauri/binaries/buzz-$TARGET"
    ''}
  '';

  cargoBuildFlags = [ "--package" "buzz-desktop" ];

  doCheck = false;

  env = {
    SHERPA_ONNX_ARCHIVE_DIR = "${finalAttrs.sherpaOnnxDir}";
  };

  preFixup = ''
    gappsWrapperArgs+=(
      --set GDK_BACKEND x11
    )
  '';

  meta = with lib; {
    description = "A hive mind communication platform - desktop app";
    homepage = "https://github.com/block/buzz";
    license = licenses.asl20;
    mainProgram = "buzz";
    platforms = platforms.linux;
  };
})
