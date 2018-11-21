{ pkgs, ... }:
with pkgs;
  let
    nixos = builtins.pathExists /etc/nixos/configuration.nix;
    optionals = lib.optionals;
  in
  # GUI networking.
  [
    tor-browser-bundle
  ] ++ optionals (nixos) [
    wireshark
  ]
