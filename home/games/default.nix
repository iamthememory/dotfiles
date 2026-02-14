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
      bottles-nixpkgs = import
        (pkgs.applyPatches {
          name = "nixpkgs-bottles-patched";
          src = inputs.nixos-unstable;
          patches = [ ./bottles-namespace.patch ];
        })
        {
          inherit (pkgs.stdenv.hostPlatform) system;
        };
    in
    [
      # A tool for running appimages.
      appimage-run

      # A tool for managing separate wine prefixes.
      bottles

      # A tool for showing OpenGL info for testing and debugging.
      mesa-demos

      # A tool for easily running games on Linux.
      lutris

      # A way of easily applying libraries to WINE prefixes.
      winetricks

      # A default wine.
      wineWow64Packages.staging
    ];

  # Install Java.
  programs.java.enable = true;
}
