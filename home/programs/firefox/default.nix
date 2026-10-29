{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  defaultProfile = "2gdsw1if.default";
  parfait = import ./parfait.nix { inherit pkgs; };
  containers = import ./containers.nix { inherit lib; };
  extensions = import ./extensions.nix { inherit pkgs inputs; };
in
{
  programs.firefox = {
    enable = true;
    package = inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.firefox;
    configPath = ".mozilla/firefox";
    profiles = {
      default = {
        id = 0;
        path = defaultProfile;
        inherit (containers) containers containersForce;
        extensions = extensions // {
          settings = containers.extensionSettings;
        };
        search = import ./search.nix { inherit pkgs; };
        settings = {
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          "svg.context-properties.content.enabled" = true;

          "extensions.autoDisableScopes" = 0;

          "sidebar.verticalTabs" = true;
          "sidebar.visibility" = "hide-sidebar";
          "browser.translations.automaticallyPopup" = false;
          "layout.spellcheckDefault" = 0;
          "signon.rememberSignons" = false;
          "browser.toolbars.bookmarks.visibility" = "always";

          "browser.urlbar.decodeURLsOnCopy" = true;
          "browser.tabs.insertAfterCurrent" = true;
          "browser.tabs.loadBookmarksInTabs" = true;
          "mousewheel.with_control.action" = 1;
          "full-screen-api.transition-duration.enter" = "0 0";
          "full-screen-api.transition-duration.leave" = "0 0";

          "pdfjs.scrollModeOnLoad" = 1;
          "pdfjs.spreadModeOnLoad" = 1;
          "pdfjs.externalLinkTarget" = 2;
          "pdfjs.enableScripting" = false;
          "reader.content_width" = 9;
          "reader.line_height" = 5;
          "reader.font_type" = "sans-serif";
          "media.autoplay.default" = 5;

          "browser.search.separatePrivateDefault.enabled" = true;
          "browser.search.separatePrivateDefault.featureGate" = true;

          "permissions.default.camera" = 2;
          "permissions.default.microphone" = 2;
          "permissions.default.geo" = 2;
          "permissions.default.desktop-notification" = 2;
          "permissions.default.shortcuts" = 2;
          "permissions.default.xr" = 2;
          "media.getusermedia.screensharing.enabled" = false;

          # Privacy preferences adapted from nyanshiba/firefox-profile-settings
          # at 7e0216b218764be55340119e941488224bb26fda.
          "browser.contentblocking.category" = "strict";
          "privacy.firstparty.isolate" = false;
          "privacy.annotate_channels.strict_list.enabled" = true;
          "dom.storage_access.auto_grants" = false;
          "network.cookie.sameSite.laxByDefault" = true;
          "network.cookie.sameSite.noneRequiresSecure" = true;
          "network.cookie.sameSite.schemeful" = true;
          "privacy.query_stripping.enabled" = true;
          "privacy.query_stripping.enabled.pbmode" = true;
          "privacy.query_stripping.strip_list" = "s t";

          "browser.cache.disk.enable" = false;
          "privacy.history.custom" = true;
          "places.history.enabled" = false;
          "browser.formfill.enable" = true;
          "browser.urlbar.suggest.history" = false;
          "privacy.sanitize.sanitizeOnShutdown" = true;
          "privacy.sanitize.clearOnShutdown.hasMigratedToNewPrefs3" = true;
          "privacy.clearOnShutdown_v2.browsingHistoryAndDownloads" = true;
          "privacy.clearOnShutdown_v2.formdata" = true;
          "privacy.clearOnShutdown_v2.cache" = true;
          "privacy.clearOnShutdown_v2.cookiesAndStorage" = false;
          "privacy.clearOnShutdown_v2.siteSettings" = false;
          "browser.sessionstore.max_serialize_back" = 0;
          "browser.sessionstore.max_serialize_forward" = 0;
          "browser.sessionstore.max_tabs_undo" = 5;
          "browser.sessionstore.max_windows_undo" = 2;
          "services.sync.declinedEngines" = "addons,history,forms";
          "services.sync.engine.addons" = false;
          "services.sync.engine.history" = false;
          "services.sync.engine.forms" = false;

          "signon.autofillForms" = false;
          "browser.search.suggest.enabled" = true;
          "browser.search.suggest.enabled.private" = false;
          "browser.urlbar.suggest.searches" = false;
          "browser.urlbar.sponsoredTopSites" = false;
          "browser.topsites.contile.enabled" = false;

          "dom.security.https_only_mode" = true;
          "dom.security.https_only_mode_pbm" = true;
          "dom.security.https_only_fire_http_request_background_timer_ms" = 1000;
          "dom.security.https_only_mode_error_page_user_suggestions" = true;
          "dom.block_download_insecure" = true;
          "security.mixed_content.block_active_content" = true;
          "security.mixed_content.block_display_content" = true;
          "security.mixed_content.upgrade_display_content" = true;
          "security.OCSP.enabled" = 0;
          "security.OCSP.require" = false;
          "security.pki.crlite_mode" = 2;
          "network.trr.mode" = 5;
        }
        // parfait.settings;
        inherit (parfait) userChrome userContent;
      };
      sub = {
        id = 1;
        path = "qdkmkbh0.h";
      };
    };
  };

  home.file."${config.programs.firefox.profilesPath}/${defaultProfile}/chrome/parfait".source =
    "${parfait.package}/parfait";
}
