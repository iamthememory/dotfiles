# Curses-like terminal utilities.
{
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    # A tool that's like top for I/O.
    iotop

    # A pager for viewing files.
    less

    # An ncurses TUI for seeing what files take up how much space on disk.
    ncdu

    # A color-enabled info viewer.
    pinfo

    # A tool to show progress of other processes by monitoring their open file
    # descriptors.
    progress

    # A tool to show the I/O rate in a pipe.
    pv

    # A shinier, colorful df alternative.
    pydf

    # A way of showing a directory tree as a tree diagram.
    tree
  ];

  # Enable lesspipe to transparently pre-process files fed to less.
  programs.lesspipe.enable = true;
}
