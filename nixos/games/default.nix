# Game-related configuration for NixOS.
{ ...
}: {
  imports = [
    ./steam.nix
    ./wine
  ];
}
