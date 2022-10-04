# Basic documentation and utilities.
{ pkgs
, ...
}: {
  # Install documentation as well for any programs.
  home.extraOutputsToInstall = [
    "bin"
    "doc"
  ];

  home.packages = with pkgs; [
    # Basic Linux manpages.
    man-pages

    # Basic POSIX standard manpages.
    man-pages-posix

    # A tool for converting and rendering things like markdown.
    pandoc

    # Manpages for the C++ standard library.
    stdman
  ];

  # Install home-manager documentation.
  manual.html.enable = true;
  manual.json.enable = true;
  manual.manpages.enable = true;

  # Enable GNU info and any info documentation for packages.
  programs.info.enable = true;

  # Enable manpages and the man program, and generate mandb caches when
  # building the generation.
  programs.man.enable = true;
  programs.man.generateCaches = true;
}
