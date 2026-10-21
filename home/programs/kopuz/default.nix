{ pkgs, lib, inputs, ... }:
let
  kopuz = inputs.kopuz.packages.${pkgs.system}.default.overrideAttrs (old: {
    postPatch = (old.postPatch or "") + ''
      substituteInPlace crates/kopuz/src/main.rs \
        --replace-fail \
          'dioxus::desktop::Config::new()' \
          'dioxus::desktop::Config::new().with_disable_dma_buf_on_wayland(false)'
    '';

    postInstall = (old.postInstall or "") + lib.optionalString pkgs.stdenv.isDarwin ''
      install -Dm644 crates/kopuz/assets/icon.icns \
        $out/bin/kopuz.app/Contents/Resources/icon.icns
      mkdir -p $out/Applications
      ln -s ../bin/kopuz.app $out/Applications/Kopuz.app
    '';
  });
in
{
  home.packages = [ kopuz ];
}
