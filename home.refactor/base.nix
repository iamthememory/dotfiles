# The base configuration used for all systems.
{
  config,
  inputs,
  ...
}: let
  unstable = inputs.unstable;
in {
  imports = [
    ./xdg.nix
  ];

  home.language.base = "en_US.UTF-8";

  home.packages = [
    # FIXME: This should be replaced with regular nix once flakes make it into
    # stable.
    unstable.nixFlakes
  ];

  # Set up the path to look up manpages.
  home.sessionVariables.MANPATH = builtins.concatStringsSep ":" [
    # Manpages installed by home-manager.
    "${config.home.profileDirectory}/share/man"

    # Manpages from the host system.
    "/run/current-system/sw/share/man"
  ];

  # Clear anything we didn't add to the PATH.
  home.sessionVariables.PATH = "";

  # Initialize the PATH.
  home.sessionPath = [
    # NixOS wrappers for setuid programs.
    "/run/wrappers/bin"

    # Programs installed by home-manager.
    "${config.home.profileDirectory}/bin"

    # Any tools from the host system that should be included.
    "/run/current-system/sw/bin"
  ];

  # This must be at least 20.09 to work properly with flakes.
  home.stateVersion = "20.09";

  # Allow unfree packages.
  # Note that this must be set here, as home-manager reimports pkgs after
  # getting its original path, stripping out any overlays or config we give it.
  nixpkgs.config.allowUnfree = true;

  # Enable the home-manager binary for managing generations.
  # NOTE: This probably won't work for building new generations for the
  # foreseeable future.
  programs.home-manager.enable = true;
  programs.home-manager.path = "${inputs.home-manager}";

  # Ensure that nix has flakes enabled.
  # FIXME: This can be removed once flakes are stable.
  xdg.configFile."nix/nix.conf".text = ''
    experimental-features = nix-command flakes
  '';
}
