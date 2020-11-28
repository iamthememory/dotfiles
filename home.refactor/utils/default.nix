# Basic terminal utilities and niceties helpful for most systems.
{
  pkgs,
  ...
}: {
  imports = [
    ./doc.nix
    ./hardware.nix
    ./media.nix
    ./net.nix
    ./tui
  ];
}
