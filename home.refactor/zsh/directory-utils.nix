# Various directory-related ZSH utilities and config snippets.
{
  ...
}: let
  # Make an alias for going up a specified number of levels, e.g.
  # (mkUpAlias 4) -> { name = "...."; value = "../../.."; }
  mkUpAlias = levels: {
    name = (builtins.concatStringsSep "" (builtins.genList (x: ".") levels));
    value = (builtins.concatStringsSep "/" (builtins.genList (x: "..") (levels - 1)));
  };

  # Make all the aliases up to the given level.
  genUpAliases = maxlevel: let
    levels = builtins.genList (n: n + 3) (maxlevel - 2);
    aliases = map (level: mkUpAlias level) levels;
  in builtins.listToAttrs aliases;
in {
  # Enable aliases for shortcuts to go up directories.
  # NOTE: These are global aliases, so they can be used anywhere within a
  # line.
  programs.zsh.shellGlobalAliases = (genUpAliases 20);
}
