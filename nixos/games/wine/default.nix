# WINE-related configuration for NixOS.
{ ...
}: {
  # Extra sysctl options.
  boot.kernel.sysctl = {
    # Enable attaching to other processes which aren't children of the attaching
    # process.
    # Wine does *not* like this set.
    "kernel.yama.ptrace_scope" = 0;
  };
}
