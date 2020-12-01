# The base configuration used for all systems.
{
  config,
  inputs,
  pkgs,
  ...
}: let
  inherit (inputs) unstable;

  homeDirectory = config.home.homeDirectory;
in {
  imports = [
    ./xdg.nix
  ];

  # Link the nixpkgs revision used for this generation in the home directory so
  # it can be used for nix repl, and also for indirection when specifying
  # NIX_PATH so that we don't have to worry about finding a way to invalidate
  # and reload that variable in all active shells after an update.
  home.file."nixpkgs".source = "${pkgs.path}";

  # Set the locale to en_US.UTF-8.
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

  # Set the NIX_PATH so tools we can't manage inside a flake (like nix repl,
  # parts of nix-index, etc.) use the same pinned revision used to build this
  # configuration.
  home.sessionVariables.NIX_PATH = "nixpkgs=${homeDirectory}/nixpkgs:nixos=${homeDirectory}/nixpkgs";

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
