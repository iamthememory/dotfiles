# Various WINE-related functions and utilities.
{ lib, ... }: {
  # A function to build wine from custom sources.
  mkWine =
    { pkgs
    , version
    , src
    , patchECDSA ? false
    , patches ? [ ]
    }:
    pkgs.wineWowPackages.base.overrideDerivation (origAttrs: {
      wineBuild = "wineWow";

      version = version;
      name = "wine-${version}";

      patches =
        origAttrs.patches
        ++ patches
        ++ lib.optional patchECDSA ./0000-re-enable-ecdsa.patch;

      inherit src;
    });
}
