# Nix configuration for nightmare
{ ...
}: {
  # Enable regularly performing garbage collection.
  #nix.gc.automatic = true;

  # Run the garbage collector at 05:35 daily, rather than the default 03:15.
  nix.gc.dates = "05:35";

  # Garbage-collect non-active profile generations older than a month.
  nix.gc.options = "--delete-older-than 30d";

  # Build with at most four cores.
  nix.settings.cores = 4;

  # Only build a single package at a time by default.
  nix.settings.max-jobs = 1;

  # Optimize the nix store later in the morning, after the garbage collector is
  # run, rather than the default 03:45.
  nix.optimise.dates = [ "06:05" ];
}
