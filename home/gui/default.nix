{ config, lib, options, ... }:
let
  inherit (import ../hostid.nix) hostname hasGui;
in
  {
    imports = if hasGui then [
        ./fonts.nix
      ]
      else [
      ];
  }
