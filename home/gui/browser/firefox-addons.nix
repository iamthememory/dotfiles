{ buildFirefoxXpiAddon, fetchurl, lib, stdenv }:
  {
    "adblock-plus" = buildFirefoxXpiAddon {
      pname = "adblock-plus";
      version = "3.16.1";
      addonId = "{d10d0bf8-f5b5-c8b4-a8b2-2b9879e08c5d}";
      url = "https://addons.mozilla.org/firefox/downloads/file/4067141/adblock_plus-3.16.1.xpi";
      sha256 = "3f22f5b20ca831a2463751ed66e3fcdf5b51f09caff390b8e7ad0a850e694bfe";
      meta = with lib;
      {
        homepage = "https://adblockplus.org/";
        description = "One of the most popular free ad blockers for Firefox. Block annoying ads on sites like Facebook, YouTube and all other websites.\n\nAdblock Plus blocks all annoying ads, and supports websites by not blocking unobtrusive ads by default (configurable).";
        license = licenses.gpl3;
        platforms = platforms.all;
        };
      };
    "adnauseam" = buildFirefoxXpiAddon {
      pname = "adnauseam";
      version = "3.16.0";
      addonId = "adnauseam@rednoise.org";
      url = "https://addons.mozilla.org/firefox/downloads/file/4040916/adnauseam-3.16.0.xpi";
      sha256 = "00b1145ab88326e904b8486530c2435ecab953e4d93f1e559116d73563edb502";
      meta = with lib;
      {
        homepage = "https://adnauseam.io";
        description = "Blocking ads and fighting back against advertising surveillance.";
        license = licenses.gpl3;
        platforms = platforms.all;
        };
      };
    "downthemall" = buildFirefoxXpiAddon {
      pname = "downthemall";
      version = "4.7.1";
      addonId = "{DDC359D1-844A-42a7-9AA1-88A850A938A8}";
      url = "https://addons.mozilla.org/firefox/downloads/file/4062424/downthemall-4.7.1.xpi";
      sha256 = "a092f7ea0ffaf321f3a09f7f50d73d6be5e98a1c71fb6b0562d47173c2c8df3d";
      meta = with lib;
      {
        homepage = "https://www.downthemall.org/";
        description = "The Mass Downloader for your browser";
        license = licenses.gpl2;
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
        platforms = platforms.all;
        };
      };
    }