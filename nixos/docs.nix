# Documentation options.
{ ...
}: {
  # Generate man page caches.
  documentation.man.generateCaches = true;

  # Install NixOS documentation.
  documentation.nixos.enable = true;
}
