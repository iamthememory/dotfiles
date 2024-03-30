{ buildFirefoxXpiAddon, fetchurl, lib, stdenv }:
  {
    "adblock-plus" = buildFirefoxXpiAddon {
      pname = "adblock-plus";
      version = "3.25";
      addonId = "{d10d0bf8-f5b5-c8b4-a8b2-2b9879e08c5d}";
      url = "https://addons.mozilla.org/firefox/downloads/file/4245699/adblock_plus-3.25.xpi";
      sha256 = "76287d2cc2032baab1cfe572214e594ff3e3896f3a764bd56341ce31d4c5e417";
      meta = with lib;
      {
        homepage = "https://adblockplus.org/";
        description = "One of the most popular free ad blockers for Firefox. Block annoying ads on sites like Facebook, YouTube and all other websites.\n\nAdblock Plus blocks all annoying ads, and supports websites by not blocking unobtrusive ads by default (configurable).";
        license = licenses.gpl3;
        mozPermissions = [
          "<all_urls>"
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
          "https://accounts.adblockplus.org/premium"
          "https://accounts.adblockplus.org/premium?*"
          "https://accounts.adblockplus.org/*/premium"
          "https://accounts.adblockplus.org/*/premium?*"
          "https://youtube.com/*"
          "https://www.youtube.com/*"
          "https://adblockplus.org/installed"
          "https://adblockplus.org/installed?*"
          "https://adblockplus.org/*/installed"
          "https://adblockplus.org/*/installed?*"
          "https://welcome.adblockplus.org/*/installed"
          "https://welcome.adblockplus.org/*/installed?*"
          ];
        platforms = platforms.all;
        };
      };
    "adnauseam" = buildFirefoxXpiAddon {
      pname = "adnauseam";
      version = "3.21.0";
      addonId = "adnauseam@rednoise.org";
      url = "https://addons.mozilla.org/firefox/downloads/file/4244829/adnauseam-3.21.0.xpi";
      sha256 = "cde20f691dfa1dcc8a77d4d64e7e0618fe277f4a8f62d72d884ac4b5d0a8f3b8";
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
          "https://*.letsblock.it/*"
          "https://github.com/uBlockOrigin/*"
          "https://ublockorigin.github.io/*"
          "https://*.reddit.com/r/uBlockOrigin/*"
          ];
        platforms = platforms.all;
        };
      };
    "downthemall" = buildFirefoxXpiAddon {
      pname = "downthemall";
      version = "4.12.1";
      addonId = "{DDC359D1-844A-42a7-9AA1-88A850A938A8}";
      url = "https://addons.mozilla.org/firefox/downloads/file/4228862/downthemall-4.12.1.xpi";
      sha256 = "4e652c23da2560d02246afa3eeeee442b6de3dddb1ee3ce10aaa214e57e676fd";
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
    "retain-me-not" = buildFirefoxXpiAddon {
      pname = "retain-me-not";
      version = "1.5.2";
      addonId = "{66da545d-d31d-4eec-a202-622d99b660c7}";
      url = "https://addons.mozilla.org/firefox/downloads/file/3012883/retain_me_not-1.5.2.xpi";
      sha256 = "8a77b062526cc4dbd29861eccb908fd04e39d0cdd8e0829a8a7334f7579f8fb6";
      meta = with lib;
      {
        description = "Free your FFXIV inventory up!\nAdditional information is added to your lodestone retainer's inventory page to help you reduce the number of occupied inventory slots.";
        license = licenses.gpl3;
        mozPermissions = [
          "storage"
          "unlimitedStorage"
          "https://retainmenot.ffxivaddons.com/*"
          "https://*.finalfantasyxiv.com/lodestone/character/*/retainer/*/baggage/"
          ];
        platforms = platforms.all;
        };
      };
    "zen-fox" = buildFirefoxXpiAddon {
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