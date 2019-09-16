{ self, super }:
  with super; super.cataclysm-dda-git.overrideDerivation (oldAttrs: rec {
    version = "2019-08-31";
    name = "cataclysm-dda-git-${version}";
    tiles = true;

    src = fetchFromGitHub {
      owner = "CleverRaven";
      repo = "Cataclysm-DDA";
      rev = "9a3586aae1adfd1ae8f57d312085d5be81c4b857";
      sha256 = "0vkvn0s5jqq24j0zgx46gqwn6cp1x8hg5bj7if63jwgizz3zxkkb";
    };

    makeFlags = builtins.filter
      (
        x:
          "${builtins.substring 0 8 x}" != "VERSION="
      )
      oldAttrs.makeFlags
    ++ [
      "VERSION=git-${version}-${builtins.substring 0 8 src.rev}"
    ];
  })
