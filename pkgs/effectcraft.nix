{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  pkg-config,
  alsa-lib,
  wayland,
  makeWrapper,
  libxkbcommon,
  vulkan-loader,
  libglvnd,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "effectcraft";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "storytold";
    repo = "effectcraft";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1OQnz8pg2msvS/SaEpxn5mkRo5E2uG6t2a0ZBsSaW8I=";
  };

  cargoLock = {
    lockFile = finalAttrs.src + "/Cargo.lock";
    outputHashes = {
      "filmcraft-aac-0.1.1" = "sha256-WXiX4rF7zSwfu3yu9aNH2/xWYhAYFVX1rdrnccuTD7g=";
      "filmcraft-ac3-0.1.1" = "sha256-WXiX4rF7zSwfu3yu9aNH2/xWYhAYFVX1rdrnccuTD7g=";
      "filmcraft-av1-0.1.1" = "sha256-WXiX4rF7zSwfu3yu9aNH2/xWYhAYFVX1rdrnccuTD7g=";
      "filmcraft-bitstream-0.1.1" = "sha256-WXiX4rF7zSwfu3yu9aNH2/xWYhAYFVX1rdrnccuTD7g=";
      "filmcraft-cfb-0.1.1" = "sha256-WXiX4rF7zSwfu3yu9aNH2/xWYhAYFVX1rdrnccuTD7g=";
      "filmcraft-codecs-0.1.1" = "sha256-WXiX4rF7zSwfu3yu9aNH2/xWYhAYFVX1rdrnccuTD7g=";
      "filmcraft-color-0.1.1" = "sha256-WXiX4rF7zSwfu3yu9aNH2/xWYhAYFVX1rdrnccuTD7g=";
      "filmcraft-dnx-0.1.1" = "sha256-WXiX4rF7zSwfu3yu9aNH2/xWYhAYFVX1rdrnccuTD7g=";
      "filmcraft-frame-0.1.1" = "sha256-WXiX4rF7zSwfu3yu9aNH2/xWYhAYFVX1rdrnccuTD7g=";
      "filmcraft-geom-0.1.1" = "sha256-WXiX4rF7zSwfu3yu9aNH2/xWYhAYFVX1rdrnccuTD7g=";
      "filmcraft-h264-0.1.1" = "sha256-WXiX4rF7zSwfu3yu9aNH2/xWYhAYFVX1rdrnccuTD7g=";
      "filmcraft-h264enc-0.1.1" = "sha256-WXiX4rF7zSwfu3yu9aNH2/xWYhAYFVX1rdrnccuTD7g=";
      "filmcraft-hevc-0.1.1" = "sha256-WXiX4rF7zSwfu3yu9aNH2/xWYhAYFVX1rdrnccuTD7g=";
      "filmcraft-interchange-0.1.1" = "sha256-WXiX4rF7zSwfu3yu9aNH2/xWYhAYFVX1rdrnccuTD7g=";
      "filmcraft-isobmff-0.1.1" = "sha256-WXiX4rF7zSwfu3yu9aNH2/xWYhAYFVX1rdrnccuTD7g=";
      "filmcraft-matroska-0.1.1" = "sha256-WXiX4rF7zSwfu3yu9aNH2/xWYhAYFVX1rdrnccuTD7g=";
      "filmcraft-media-0.1.1" = "sha256-WXiX4rF7zSwfu3yu9aNH2/xWYhAYFVX1rdrnccuTD7g=";
      "filmcraft-mpeg2v-0.1.1" = "sha256-WXiX4rF7zSwfu3yu9aNH2/xWYhAYFVX1rdrnccuTD7g=";
      "filmcraft-mpegts-0.1.1" = "sha256-WXiX4rF7zSwfu3yu9aNH2/xWYhAYFVX1rdrnccuTD7g=";
      "filmcraft-mxf-0.1.1" = "sha256-WXiX4rF7zSwfu3yu9aNH2/xWYhAYFVX1rdrnccuTD7g=";
      "filmcraft-ogg-0.1.1" = "sha256-WXiX4rF7zSwfu3yu9aNH2/xWYhAYFVX1rdrnccuTD7g=";
      "filmcraft-opus-0.1.1" = "sha256-WXiX4rF7zSwfu3yu9aNH2/xWYhAYFVX1rdrnccuTD7g=";
      "filmcraft-project-0.1.1" = "sha256-WXiX4rF7zSwfu3yu9aNH2/xWYhAYFVX1rdrnccuTD7g=";
      "filmcraft-prores-0.1.1" = "sha256-WXiX4rF7zSwfu3yu9aNH2/xWYhAYFVX1rdrnccuTD7g=";
      "filmcraft-time-0.1.1" = "sha256-WXiX4rF7zSwfu3yu9aNH2/xWYhAYFVX1rdrnccuTD7g=";
      "filmcraft-vp9-0.1.1" = "sha256-WXiX4rF7zSwfu3yu9aNH2/xWYhAYFVX1rdrnccuTD7g=";
    };
  };

  cargoBuildFlags = [ "-p" "effectcraft" "-p" "effectcraft-cli" ];

  doCheck = false;

  nativeBuildInputs = lib.optionals stdenv.isLinux [ pkg-config makeWrapper ];
  buildInputs = lib.optionals stdenv.isLinux [
    alsa-lib
    wayland
    libxkbcommon
  ];

  postInstall = lib.optionalString stdenv.isLinux ''
    for bin in effectcraft effectcraft-cli; do
      wrapProgram $out/bin/$bin --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          alsa-lib
          wayland
          libxkbcommon
          vulkan-loader
          libglvnd
        ]
      } --set __EGL_VENDOR_LIBRARY_DIRS /run/opengl-driver/share/glvnd/egl_vendor.d
    done

    install -Dm644 packaging/linux/ai.storyteller.effectcraft.desktop \
      $out/share/applications/ai.storyteller.effectcraft.desktop

    for size in 16x16 24x24 32x32 48x48 64x64 128x128 256x256 512x512; do
      install -Dm644 assets/app-icon/hicolor/$size/apps/ai.storyteller.effectcraft.png \
        $out/share/icons/hicolor/$size/apps/ai.storyteller.effectcraft.png
    done
  '';

  meta = with lib; {
    description = "Motion graphics and visual effects; an open-source reimplementation of Adobe After Effects";
    homepage = "https://github.com/storytold/effectcraft";
    license = with licenses; [ mit asl20 ];
    mainProgram = "effectcraft";
    platforms = platforms.linux ++ platforms.darwin;
  };
})
