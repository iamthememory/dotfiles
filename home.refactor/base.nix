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

  # Clear anything we didn't add to the PATH.
  home.sessionVariables.PATH = "";

  # Initialize the PATH.
  home.sessionPath = [
    # NixOS wrappers for setuid programs.
    "/run/wrappers/bin"

    # Programs installed by home-manager.
    "${config.home.homeDirectory}/.nix-profile/bin"

    # Any tools from the host system that should be included.
    "/run/current-system/sw/bin"
  ];
}
