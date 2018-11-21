{ self, super }:
  with super; super.cataclysm-dda-git.overrideDerivation (oldAttrs: rec {
    version = "2018-10-29";
    name = "cataclysm-dda-git-${version}";
    tiles = false;

    src = fetchFromGitHub {
      owner = "CleverRaven";
      repo = "Cataclysm-DDA";
      rev = "46e2480318bb226d34f7b297075381258e9fb5e0";
      sha256 = "01fw40rcpk94qcv174vk2bcl3z4359ypz34vrw2zd4yx4lnb0rmq";
    };

    patches = [];

    makeFlags = builtins.filter
      (
        x:
          x != "TILES=1"
          && x != "SOUND=1"
          && "${builtins.substring 0 8 x}" != "VERSION="
      )
      oldAttrs.makeFlags
    ++ [
      "VERSION=git-${version}-${builtins.substring 0 8 src.rev}"
    ];
  })
