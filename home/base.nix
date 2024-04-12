# The base configuration used for all systems.
{ config
, inputs
, lib
, pkgs
, ...
}:
let
  inherit (config.home) homeDirectory;
in
{
  imports = [
    ./xdg.nix

    # Import any custom home-manager modules.
    # NOTE: Nix doesn't like this being provided through inputs, and I don't
    # entirely know why, so we're including it here, even if that's kinda ugly.
    # Maybe something to do with when the module argument(s) are processed vs
    # imports, or something, but it gives infinite recursion.
    ../hm-modules
  ];

  # A link to the current generation's source.
  home.file."generation".source = "${inputs.flake.sourceInfo}";

  # The current generation's revision.
  home.file."generation.rev".text = inputs.flake.rev or "dirty";

  # Link the nixpkgs revision used for this generation in the home directory so
  # it can be used for nix repl, and also for indirection when specifying
  # NIX_PATH so that we don't have to worry about finding a way to invalidate
  # and reload that variable in all active shells after an update.
  home.file."nixpkgs".source = "${pkgs.path}";

  # Set the locale to en_US.UTF-8.
  home.language.base = "en_US.UTF-8";

  home.packages = with pkgs; [
    # Ensure systemctl, etc. is available.
    systemd
  ];

  # Set up the path to look up manpages.
  home.sessionVariables.MANPATH = builtins.concatStringsSep ":" [
    # Manpages installed by home-manager.
    "${config.home.profileDirectory}/share/man"

    # Manpages in the host system.
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

  # Only update this after checking the changelog after a new
  # home-manager state version.
  home.stateVersion = "23.05";

  # The nix package to check the nix user configuration against.
  nix.package = pkgs.nix;

  # The user registry of extra flake identifiers, to more quickly reference
  # flakes without the full repo URL.
  nix.registry =
    let
      mkGithubFlake =
        { repo
        , owner ? "nix-community"
        , id ? repo
        }: {
          "${id}" = {
            to.owner = owner;
            to.repo = repo;
            to.type = "github";
          };
        };

      githubFlakes = [
        # Useful flake utilities.
        {
          owner = "numtide";
          repo = "flake-utils";
        }

        # A way of managing a home configuration in nix.
        {
          repo = "home-manager";
        }

        # Utilities for building rust projects.
        {
          repo = "naersk";
        }
      ];
    in
    builtins.foldl' (x: y: x // y) { } (builtins.map mkGithubFlake githubFlakes);

  # Ensure that nix has flakes enabled.
  # FIXME: This can be removed once flakes are stable.
  nix.settings.experimental-features = "nix-command flakes";

  # Set the configuration for nixpkgs used in home-manager from the top-level
  # config.
  nixpkgs.config = import inputs.nixpkgs-config;

  # Set the overlay for nixpkgs used in home-manager from the top-level
  # overlay.
  nixpkgs.overlays = [
    (import inputs.overlay)
  ];

  # Enable the home-manager binary for managing generations.
  # NOTE: This probably won't work for building new generations for the
  # foreseeable future.
  programs.home-manager.enable = true;
  programs.home-manager.path = lib.mkDefault "${inputs.home-manager}";

  # (Re)start services on generation activation.
  systemd.user.startServices = "legacy";

  # Set the nixpkgs config for the system from the config we use here.
  xdg.configFile."nixpkgs/config.nix".source = inputs.nixpkgs-config;

  # Link the overlay we use here into the default user overlays location.
  # This will make it easy to use the same overlayed packages from here in
  # tools outside home-manager.
  xdg.configFile."nixpkgs/overlays/dotfile-overlay".source = inputs.overlay;
}
