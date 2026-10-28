{ pkgs, inputs }:
let
  addons = (pkgs.extend inputs.firefox-addons.overlays.default).firefox-addons;
  #inherit (addons) buildFirefoxXpiAddon;
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
    raindropio
    #soundfixer
    #traduzir-paginas-web
  ];
}
