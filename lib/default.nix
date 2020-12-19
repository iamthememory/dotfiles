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

  # Build a vim plugin from the given input and name.
  mkVimPlugin =
    { src
    , pname
    ,
    }: pkgs.vimUtils.buildVimPluginFrom2Nix {
      inherit pname src;

      version = src.lastModifiedDate;
    };
}
