{ pkgs, ... }:
with pkgs;
  let
    nixos = builtins.pathExists /etc/nixos/configuration.nix;
    optionals = lib.optionals;
  in
  # Games.
  [
    cataclysm-dda-git
    nethack
    steam
    steam-run
    tinyfugue
  ] ++ optionals (nixos) [
    scanmem
  ]
