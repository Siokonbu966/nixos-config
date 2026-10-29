{ pkgs, inputs }:
let
  addons = (pkgs.extend inputs.firefox-addons.overlays.default).firefox-addons;
  soundfixerXpi = pkgs.fetchFirefoxAddon {
    name = "soundfixer-1.4.1";
    url = "https://addons.mozilla.org/firefox/downloads/file/4205769/soundfixer-1.4.1.xpi";
    sha256 = "b229c77635e4e89ab586144aea2fcc977a2c5e51509a84ac884fa59e29ee7792";
  };
  soundfixer = pkgs.runCommand "soundfixer-1.4.1" { inherit soundfixerXpi; } ''
    mkdir -p $out/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}
    cp $soundfixerXpi/*.xpi $out/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/soundfixer@unrelenting.technology.xpi
  '' // {
    addonId = "soundfixer@unrelenting.technology";
    extid = "soundfixer@unrelenting.technology";
  };
in
{
  packages = with addons; [
    containerise
    wappalyzer
    nos2x-fox
    keepa
    linkding-extension
    refined-github
    wayback-machine
    zotero-connector
    vimium
    enhancer-for-youtube
    feedbroreader
    proton-pass
    ublock-origin
    soundfixer
    #traduzir-paginas-web
  ];
}
