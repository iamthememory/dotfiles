# Nix configuration for nightmare
{ ...
}: {
  # Build with at most four cores.
  nix.buildCores = 4;

  # Enable regularly performing garbage collection.
  nix.gc.automatic = true;

  # Run the garbage collector at 05:35 daily, rather than the default 03:15.
  nix.gc.dates = "05:35";

  # Garbage-collect non-active profile generations older than two weeks.
  # Given that older flake commits can be reliably recreated, this is likely
  # safe even at shorter periods than this.
  nix.gc.options = "--delete-older-than 14d";

  # Only build a single package at a time by default.
  nix.maxJobs = 1;

  # Optimize the nix store later in the morning, after the garbage collector is
  # run, rather than the default 03:45.
  nix.optimise.dates = [ "06:05" ];
}
