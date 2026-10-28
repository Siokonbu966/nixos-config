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
    ipfs-companion
    keepa
    instapaper-official
    linkding-extension
    refined-github
    wayback-machine
    zotero-connector
    are-na
    vimium
    enhancer-for-youtube
    feedbroreader
    #plamo-translate
    proton-pass
    raindropio
    #soundfixer
    #traduzir-paginas-web
  ];
}
