{ pkgs, inputs, ... }:
let
  kopuz = inputs.kopuz.packages.${pkgs.system}.default.overrideAttrs (old: {
    postPatch = (old.postPatch or "") + ''
      substituteInPlace crates/kopuz/src/main.rs \
        --replace-fail \
          'dioxus::desktop::Config::new()' \
          'dioxus::desktop::Config::new().with_disable_dma_buf_on_wayland(false)'
    '';
  });
in
{
  home.packages = [ kopuz ];
}
