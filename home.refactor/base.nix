# The base configuration used for all systems.
{
  config,
  pkgs,
  inputs,
  ...
}: let
  unstable = inputs.unstable;
in {
  home.language.base = "en_US.UTF-8";

  home.packages = [
    # FIXME: This should be replaced with regular nix once flakes make it into
    # stable.
    unstable.nixFlakes
  ];

  # This must be at least 20.09 to work properly with flakes.
  home.stateVersion = "20.09";
}
