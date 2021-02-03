# Various utility and library functions.
{
  # nixpkgs, so we can use its library functions to build on.
  pkgs
, ...
}: {
  # If attr is an attribute of the given set, return (mkDefault set.attr),
  # otherwise null.
  # This is useful for cases where a setting should default to an existing
  # value, but due to its type, must be truly null if it has no setting, e.g.,
  # so it can be filtered out.
  defaultOrNull = set: attr:
    if builtins.hasAttr attr set then
      pkgs.lib.mkDefault (builtins.getAttr attr set)
    else
      null;

  # Filter null and empty attributes from an attribute set.
  filterNullOrEmpty =
    let
      inherit (pkgs.lib) filterAttrs;

      # True for non-null, non-empty values in the set.
      notNullOrEmpty = n: v: v != null && v != { };
    in
    set: filterAttrs notNullOrEmpty set;

  # Various mail functions.
  mail = import ./mail-account.nix;

  # Wine related functions.
  wine = import ./wine { lib = pkgs.lib; };

  # Ensure a symlink exists or create one on profile activation.
  # - lib: home-manager's lib, for DAG functions.
  # - target: Where the symlink should point.
  # - link: Where the symlink should be.
  mkSymlink =
    let
      # The path to ln.
      ln = "${pkgs.coreutils}/bin/ln";

      # The path to readlink.
      readlink = "${pkgs.coreutils}/bin/readlink";
    in
    { lib
    , link
    , target
    }:
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      if [ ! -e "${link}" ]
      then
        $VERBOSE_ECHO "Linking ${link} -> ${target}"
        $DRY_RUN_CMD ${ln} -s $VERBOSE_ARG "${target}" "${link}"
      else
        if [ -L "${link}" ] && [ "$(${readlink} "${link}")" = "${target}" ]
        then
          $VERBOSE_ECHO "Link ${link} -> ${target} already exists"
        else
          errorEcho "${link} must be a symlink to ${target}"
          exit 1
        fi
      fi
    '';

  # Build a vim plugin from the given input and name.
  mkVimPlugin =
    { src
    , pname
    ,
    }: pkgs.vimUtils.buildVimPluginFrom2Nix {
      inherit pname src;

      version = src.lastModifiedDate;
    };

  # Solarized colors.
  solarized = import ./solarized-colors.nix;
}
