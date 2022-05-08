# Game-related packages and configuration.
{ inputs
, pkgs
, ...
}:
let
  # A build of WINE using the patches Lutris uses.
  lutrisWine = inputs.lib.wine.mkWine {
    inherit pkgs;

    src = inputs.lutris-7_2;
    version = "lutris-7.2";
  };
in
{
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
    in
    [
      # A tool for running appimages.
      appimage-run

      # A tool for showing OpenGL info for testing and debugging.
      glxinfo

      # A tool for easily running games on Linux.
      lutris

      # A build of WINE using Lutris patches.
      lutrisWine

      # A way of easily applying libraries to WINE prefixes.
      winetricks
    ];

  # Install Java.
  programs.java.enable = true;
}
