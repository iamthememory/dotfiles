# Terminal setup for st.
{ config
, pkgs
, ...
}:
let
  st = pkgs.st.overrideAttrs (oldAttrs: {
    # Override the default configuration for st with a customized one.
    configFile = pkgs.substituteAll {
      # Substitute @default_shell@ with ZSH in our current profile.
      default_shell = "${config.home.profileDirectory}/bin/zsh";

      # The name of the file to generate.
      name = "config.h";

      # The file to substitute in.
      src = ./config.h;
    };
  });
in
{
  home.packages = [
    st
  ];
}
