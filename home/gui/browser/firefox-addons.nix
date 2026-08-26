{ buildMozillaXpiAddon, fetchurl, lib, stdenv }:
  {
    "adblock-plus" = buildMozillaXpiAddon {
      pname = "adblock-plus";
      version = "4.43.2";
      addonId = "{d10d0bf8-f5b5-c8b4-a8b2-2b9879e08c5d}";
      url = "https://addons.mozilla.org/firefox/downloads/file/4966550/adblock_plus-4.43.2.xpi";
      sha256 = "5a733d6e14afeb1cfa1505527e7ab427194e44c46b522c948356ddce0f05edba";
      meta = with lib;
      {
        homepage = "https://adblockplus.org/";
        description = "One of the most popular free ad blockers for Firefox. Block annoying ads on sites like Facebook, YouTube and all other websites.\n\nAdblock Plus blocks all annoying ads, and supports websites by not blocking unobtrusive ads by default (configurable).";
        license = licenses.gpl3;
        mozPermissions = [
          "<all_urls>"
          "alarms"
          "contextMenus"
          "notifications"
          "storage"
          "tabs"
          "unlimitedStorage"
          "webNavigation"
          "webRequest"
          "webRequestBlocking"
          "devtools"
          "http://*/*"
          "https://*/*"
          "*://*.youtube.com/*"
          "https://youtube.com/*"
          "https://www.youtube.com/*"
          "https://accounts.adblockplus.org/*"
          "https://*.myaccount.adblockplus.org/*"
          "https://adblockplus.org/*"
          "https://new.adblockplus.org/*"
          "https://welcome.adblockplus.org/*"
          "https://getadblock.com/*"
          "https://vpn.getadblock.com/*"
          "https://*.myaccount.getadblock.com/*"
          "https://btloader.com/trustedIframe.html?o=*"
          "*://*.facebook.com/*"
        ];
        platforms = platforms.all;
      };
    };
    "adnauseam" = buildMozillaXpiAddon {
      pname = "adnauseam";
      version = "3.28.8";
      addonId = "adnauseam@rednoise.org";
      url = "https://addons.mozilla.org/firefox/downloads/file/4909199/adnauseam-3.28.8.xpi";
      sha256 = "fa2aa99c4a3c766514d72a9e9dcc29b3e5b5f8b58072b0d7c495f0c895b72ce0";
      meta = with lib;
      {
        homepage = "https://adnauseam.io";
        description = "Blocking ads and fighting back against advertising surveillance.";
        license = licenses.gpl3;
        mozPermissions = [
          "alarms"
          "dns"
          "menus"
          "privacy"
          "storage"
          "tabs"
          "unlimitedStorage"
          "webNavigation"
          "webRequest"
          "webRequestBlocking"
          "management"
          "<all_urls>"
          "http://*/*"
          "https://*/*"
          "file://*/*"
          "https://easylist.to/*"
          "https://*.fanboy.co.nz/*"
          "https://filterlists.com/*"
          "https://forums.lanik.us/*"
          "https://github.com/*"
          "https://*.github.io/*"
          "https://github.com/uBlockOrigin/*"
          "https://ublockorigin.github.io/*"
          "https://*.reddit.com/r/uBlockOrigin/*"
        ];
        platforms = platforms.all;
      };
    };
    "downthemall" = buildMozillaXpiAddon {
      pname = "downthemall";
      version = "4.15.1";
      addonId = "{DDC359D1-844A-42a7-9AA1-88A850A938A8}";
      url = "https://addons.mozilla.org/firefox/downloads/file/4825019/downthemall-4.15.1.xpi";
      sha256 = "a6f53822b708b4cb595195f25818fb0eeb690e1244ca2d7fc0d0b645c4dc5de9";
      meta = with lib;
      {
        homepage = "https://www.downthemall.org/";
        description = "The Mass Downloader for your browser";
        license = licenses.gpl2;
        mozPermissions = [
          "<all_urls>"
          "contextMenus"
          "downloads"
          "downloads.open"
          "history"
          "menus"
          "notifications"
          "sessions"
          "storage"
          "tabs"
          "theme"
          "webNavigation"
        ];
        platforms = platforms.all;
      };
    };
    "zen-fox" = buildMozillaXpiAddon {
      pname = "zen-fox";
      version = "1.9.9";
      addonId = "{4b7db180-f46c-4955-afaf-a03913751acc}";
      url = "https://addons.mozilla.org/firefox/downloads/file/3692640/zen_fox-1.9.9.xpi";
      sha256 = "bac5c909de8f17473ba6823999927e809ee8e9c2165a94f40c1f521a1396cb5e";
      meta = with lib;
      {
        homepage = "https://github.com/mr-islam/zen-fox";
        description = "Theme Firefox to suit you, day or night, solarized.\n\nFirefox has never looked this good.";
        license = licenses.gpl2;
        mozPermissions = [ "storage" "theme" "alarms" ];
        platforms = platforms.all;
      };
    };
  }