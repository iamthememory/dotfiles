# Basic terminal utilities and niceties helpful for most systems.
{
  pkgs,
  ...
}: {
  imports = [
    ./doc.nix
    ./net.nix
  ];
}
