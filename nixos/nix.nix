# Nix configuration.
{ inputs
, lib
, pkgs
, ...
}: {
  # Detect duplicate files in the store and hardlink them to save space.
  nix.autoOptimiseStore = true;

  # Give the nix build daemon low IO and CPU priority.
  nix.daemonIONiceLevel = lib.mkDefault 7;
  nix.daemonNiceLevel = lib.mkDefault 19;

  # Extra options for nix.
  nix.extraOptions = ''
    # Ensure the newer nix commands and flake support are enabled.
    # Additionally, enable content-addressed features.
    # FIXME: Remove this once these are enabled in stable nix.
    experimental-features = ca-derivations ca-references flakes nix-command

    # If a binary substitute fails, build from source.
    fallback = true

    # Keep around the derivations for any store paths that aren't
    # garbage-collected.
    keep-derivations = true

    # Keep all outputs of non-garbage-collected derivations.
    # For example, if x.bin is reachable from a GC root, then x.lib, x.dev,
    # x.man, etc. are kept from being garbage-collected.
    keep-outputs = true
  '';

  # Regularly find identical files in the nix store and hardlink them to save
  # space.
  nix.optimise.automatic = true;

  # Users who have additional privileges with the Nix daemon.
  nix.trustedUsers = [
    # Root should have additional privileges.
    "root"

    # Users who can sudo to root should be given additional privileges, since
    # they could just switch to root anyway.
    "@wheel"
  ];

  # The configuration to use for nixpkgs.
  nixpkgs.config = import inputs.nixpkgs-config;

  # Set the overlays to use for nixpkgs to the top-level overlay.
  nixpkgs.overlays = [
    (import inputs.overlay)
  ];
}
