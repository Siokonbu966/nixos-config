{ pkgs, ... }:
let
  kosugi-maru = pkgs.stdenv.mkDerivation {
    pname = "kosugi-maru";
    version = "1.0";

    src = pkgs.fetchurl {
      url = "https://fonts.gstatic.com/s/kosugimaru/v17/0nksC9PgP_wGh21A2KeqGiTq.ttf";
      sha256 = "139n97ymjra2pphmf79g7z8pqpibjd26i3yam7nd7aa6c7ay7yv0";
    };

    dontUnpack = true;

    installPhase = ''
      mkdir -p $out/share/fonts/truetype
      cp $src $out/share/fonts/truetype/KosugiMaru-Regular.ttf
    '';
  };

  gen-interface-jp = pkgs.stdenv.mkDerivation {
    pname = "gen-interface-jp";
    version = "0.8.0";

    src = pkgs.fetchzip {
      url = "https://github.com/yamatoiizuka/gen-interface-jp/releases/download/v0.8.0/GenInterfaceJP-0.8.0.zip";
      sha256 = "sha256-vEPYe1T2/TmsEkvAljC++dwbAXTqF1JBEhUZ1kBGTiI=";
    };

    dontBuild = true;

    installPhase = ''
      mkdir -p $out/share/fonts/truetype
      find . -path '*/Gen Interface JP/GenInterfaceJP-*.ttf' \
        -exec cp {} $out/share/fonts/truetype/ \;
    '';
  };
in {
  # fonts
  fonts.packages = with pkgs; [
    gen-interface-jp
    kosugi-maru
    nerd-fonts.meslo-lg
    nerd-fonts.mononoki
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    font-awesome
  ];
}
