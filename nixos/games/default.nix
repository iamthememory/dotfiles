# Game-related configuration for NixOS.
{ ...
}: {
  imports = [
    ./gamemode.nix
    ./steam.nix
    ./wine
  ];
}
