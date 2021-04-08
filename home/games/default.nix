# Game-related packages and configuration.
{ inputs
, pkgs
, ...
}:
let
  # A build of WINE using the patches Lutris uses.
  lutrisWine = inputs.lib.wine.mkWine {
    inherit pkgs;

    src = inputs.lutris-6_0;
    version = "lutris-6.0";
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

      # The JAVA runtime.
      jre

      # A tool for easily running games on Linux.
      lutris

      # A build of WINE using Lutris patches.
      lutrisWine

      # A way of easily applying libraries to WINE prefixes.
      winetricks
    ];
}
