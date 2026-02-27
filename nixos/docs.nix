# Documentation options.
{ ...
}: {
  # Generate man page caches.
  documentation.man.cache.enable = true;

  # Install NixOS documentation.
  documentation.nixos.enable = true;
}
