{ config, lib, options, ... }:
let
  inherit (import ../hostid.nix) hostname hasGui hasGames;

  inherit (import ../channels.nix) unstable;
  pkgs = unstable;
in
  {
    home.packages = with pkgs; [
      nethack
    ];

    home.file.".nethackrc" = {
      source = ./nethackrc;
    };
  }
