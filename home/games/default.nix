# Game-related packages and configuration.
{ inputs
, pkgs
, ...
}: {
  imports = [
    ./cli.nix
    ./gui.nix
  ];

  home.packages = with pkgs;
    let
      # Only use native libraries for steam-run, rather than the older libraries
      # in its runtime.
      steam-run = (steam.override {
        nativeOnly = true;
      }).run;

      # Patch nixpkgs to tweak the bottles FHS environment to share IPC and PID
      # namespaces.
      bottles-nixpkgs = import (pkgs.applyPatches {
        name = "nixpkgs-bottles-patch";
        src = inputs.nixos-unstable;
        patches = [ ./bottles-namespace.patch ];
      }) {
        inherit (pkgs) system;
      };
    in
    [
      # A tool for running appimages.
      appimage-run

      # A tool for managing separate wine prefixes.
      bottles-nixpkgs.bottles

      # A tool for showing OpenGL info for testing and debugging.
      glxinfo

      # A tool for easily running games on Linux.
      lutris

      # A way of easily applying libraries to WINE prefixes.
      winetricks

      # A default wine.
      wineWowPackages.staging
    ];

  # Install Java.
  programs.java.enable = true;
}
