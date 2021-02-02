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
  home.packages = with pkgs; [
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

    # A tool for running games and other binaries under the same FHS environment
    # used for Steam.
    steam-run

    # A way of easily applying libraries to WINE prefixes.
    winetricks
  ];
}
