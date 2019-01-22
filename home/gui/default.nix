{ config, lib, options, ... }:
let
  inherit (import ../hostid.nix) hostname hasGui;

  inherit (import ../channels.nix) unstable;
  lib = unstable.lib;
in
  {
    imports = lib.optionals hasGui [
      ./fonts.nix
      ./i3wm
      ./kitty.nix
      ./lock.nix
    ];
  }
