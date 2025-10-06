# Nix configuration.
{ inputs
, lib
, pkgs
, ...
}: {
  # Prefer to run things besides the nix daemon when under load.
  nix.daemonCPUSchedPolicy = lib.mkDefault "idle";
  nix.daemonIOSchedClass = lib.mkDefault "idle";
  nix.daemonIOSchedPriority = lib.mkDefault 7;

  # Regularly find identical files in the nix store and hardlink them to save
  # space.
  nix.optimise.automatic = true;

  # Detect duplicate files in the store and hardlink them to save space.
  nix.settings.auto-optimise-store = true;

  # Ensure the newer nix commands and flake support are enabled.
  # Additionally, enable content-addressed features.
  # FIXME: Remove this once these are enabled in stable nix.
  nix.settings.experimental-features = [
    "ca-derivations"
    "flakes"
    "nix-command"
  ];

  # If a binary substitute fails, build from source.
  nix.settings.fallback = true;

  # Keep around the derivations for any store paths that aren't
  # garbage-collected.
  nix.settings.keep-derivations = true;

  # Keep all outputs of non-garbage-collected derivations.
  # For example, if x.bin is reachable from a GC root, then x.lib, x.dev, x.man,
  # etc. are kept from being garbage-collected.
  nix.settings.keep-outputs = true;

  # Extra caches.
  nix.settings.substituters = [
    # The nix-community cachix, which among other things, has CUDA builds, which
    # are very slow and expensive to rebuild.
    "https://nix-community.cachix.org"
  ];

  # Trusted keys.
  nix.settings.trusted-public-keys = [
    # Trust the nix-community cache.
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
  ];

  # Users who have additional privileges with the Nix daemon.
  nix.settings.trusted-users = [
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
