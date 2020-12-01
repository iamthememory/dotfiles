# Basic terminal utilities and niceties helpful for most systems.
{
  pkgs,
  ...
}: let
  # Various common shell aliases.
  shellAliases = {
    # Enable color for common tools when in a terminal that supports it.

    exa = "${pkgs.exa}/bin/exa --color=auto";

    egrep = "${pkgs.gnugrep}/bin/egrep --color=auto";
    fgrep = "${pkgs.gnugrep}/bin/fgrep --color=auto";
    grep = "${pkgs.gnugrep}/bin/grep --color=auto";

    ls = "${pkgs.coreutils}/bin/ls --color=auto";

    # Use reflinks when able to to benefit from CoW filesystems.
    cp = "${pkgs.coreutils}/bin/cp --reflink=auto";
  };
in {
  imports = [
    ./direnv.nix
    ./doc.nix
    ./hardware.nix
    ./media.nix
    ./net.nix
    ./nix-index.nix
    ./pazi.nix
    ./scripting.nix
    ./tui
  ];

  home.packages = with pkgs; [
    # A cat clone that does syntax highlighting.
    bat

    # A basic terminal calculator useful for some scripting.
    bc

    # A (de)compressor for .bz2.
    bzip2

    # Basic GNU core utilities.
    coreutils

    # A tool for converting files between Windows-y CRLFs and *nixy LF line
    # endings.
    dos2unix

    # A shiny alternative to ls written in rust.
    exa

    # The file utility for identifying file contents and MIMEs.
    file

    # Basic low-level utilities such as getconf, iconv, ldd, and locale.
    glibc.bin

    # The GNU grep.
    gnugrep

    # The GNU tape archive/tarball archiver/extractor.
    gnutar

    # A (de)compressor for .gz.
    gzip

    # A tool for manipulating and searching JSON in terminal pipelines.
    jq

    # A tool to show what file descriptors processes have open.
    lsof

    # A (de)compressor for .7z files.
    # NOTE: This is the maintained fork, not the abandoned original p7zip.
    p7zip

    # A tool for binary patching ELF files and their library paths,
    # interpreters, etc.
    # This is useful for occasionally patching Steam games and other random
    # binaries to run outside of a FHS-y chroot.
    patchelf

    # Various process and /proc utilities, such as kill, ps, uptime watch,,
    # etc.
    procps

    # Utilities for /proc, such as fuser, killall, etc.
    psmisc

    # A utility for seeing the CPU/wall time a process uses, as well as various
    # memory/resource usage after it finishes.
    # This is a more featureful version of the usual shell builtin.
    time

    # A hexdumper/undumper, useful for trying to edit binaries in (neo)vim.
    unixtools.xxd

    # An unarchiver for .rar.
    unrar

    # An unarchiver for .zip.
    unzip

    # A variety of a bunch of standard Linux tools (with curses when
    # applicable).
    utillinuxCurses

    # A (de)compressor for .xz.
    xz

    # A tool for manipulating and searching YAML in terminal pipelines.
    # Essentially jq for YAML.
    yq

    # An archiver and set of tools for .zip.
    zip

    # A (de)compressor for .zst.
    zstd
  ];

  # Add the common shell aliases for all shells.
  # NOTE: These will have no effect unless the relevant shell is enabled.
  programs.bash.shellAliases = shellAliases;
  programs.fish.shellAliases = shellAliases;
  programs.zsh.shellAliases = shellAliases;
}
