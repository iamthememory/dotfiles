# Basic terminal utilities and niceties helpful for most systems.
{
  pkgs,
  ...
}: {
  imports = [
    ./doc.nix
    ./media.nix
    ./net.nix
    ./tui
  ];
}
