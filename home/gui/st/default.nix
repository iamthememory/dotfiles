# Terminal setup for st.
{ config
, pkgs
, ...
}:
let
  st = pkgs.st.overrideAttrs (oldAttrs: {
    # Override the default configuration for st with a customized one.
    configFile = pkgs.replaceVars ./config.h {
      # Substitute @default_shell@ with ZSH in our current profile.
      default_shell = "${config.home.profileDirectory}/bin/zsh";
    };
  });
in
{
  home.packages = [
    st
  ];
}
