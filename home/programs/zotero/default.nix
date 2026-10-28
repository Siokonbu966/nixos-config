{ pkgs, ... }:
{
  # Backport Zotero's fix for ESR 140.15+ rejecting chrome-created blob URLs.
  home.packages = [
    (pkgs.zotero.overrideAttrs (old: {
      patches = (old.patches or [ ]) ++ [ ./hidden-browser-parent-load.patch ];
    }))
  ];
}
