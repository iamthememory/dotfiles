# Curses-like terminal utilities.
{ config
, pkgs
, ...
}: {
  imports = [
    ./htop.nix
  ];

  home.packages = with pkgs; [
    # A tool for making project directories from templates.
    cookiecutter

    # An ncurses TUI for seeing what files take up how much space on disk.
    gdu

    # A tool that's like top for I/O.
    iotop

    # A pager for viewing files.
    less

    # A tool to see the space taken up by nix store gc-roots.
    nix-du

    # A TUI to browse the dependencies of a nix store path.
    nix-tree

    # Several important terminal utilities, like clear, infocmp, reset, tput,
    # etc. are provided directly by ncurses.
    # This is set to low priority so that any terminfo files installed by
    # terminals like st override the ones provided in ncurses.
    (pkgs.lowPrio ncurses)

    # A color-enabled info viewer.
    pinfo

    # A tool to show progress of other processes by monitoring their open file
    # descriptors.
    progress

    # A tool to show the I/O rate in a pipe.
    pv

    # A shinier, colorful df alternative.
    pydf

    # A TUI for viewing /sys nodes along with documentation.
    systeroid

    # A way of showing a directory tree as a tree diagram.
    tree
  ];

  # Let less output control characters for, e.g., coloring.
  home.sessionVariables.LESS = "-R";

  # Use less as the default pager.
  home.sessionVariables.PAGER = "${config.home.profileDirectory}/bin/less";

  # Enable fastfetch, a way of showing system information.
  programs.fastfetch.enable = true;

  # Enable lesspipe to transparently pre-process files fed to less.
  programs.lesspipe.enable = true;
}
