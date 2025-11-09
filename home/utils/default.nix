# Basic terminal utilities and niceties helpful for most systems.
{ config
, inputs
, lib
, pkgs
, ...
}: {
  imports = [
    ./bat.nix
    ./direnv.nix
    ./doc.nix
    ./fzf.nix
    ./hardware.nix
    ./media.nix
    ./net.nix
    ./nix-index.nix
    ./pazi.nix
    ./pet.nix
    ./scripting.nix
    ./tui
  ];

  home.packages = with pkgs; [
    # A grep-like tool for large source trees.
    ack

    # A basic terminal calculator useful for some scripting.
    bc

    # Some low-level binary utilities such as nm, objdump, readelf, strings,
    # strip, etc.
    binutils

    # A (de)compressor for .bz2.
    bzip2

    # A line of code counter.
    cloc

    # Basic GNU core utilities.
    coreutils

    # A tool for manipulating CSV files.
    csvkit

    # A tool for managing development environments.
    devenv

    # Tools such as diff, cmp, etc.
    diffutils

    # A tool for converting files between Windows-y CRLFs and *nixy LF line
    # endings.
    dos2unix

    # The file utility for identifying file contents and MIMEs.
    file

    # Utilities such as find, xargs, locate/updatedb, etc.
    findutils

    # Basic low-level utilities such as getconf, iconv, ldd, and locale.
    glibc.bin

    # The GNU grep.
    gnugrep

    # The GNU sed implementation.
    gnused

    # The GNU tape archive/tarball archiver/extractor.
    gnutar

    # A (de)compressor for .gz.
    gzip

    # A tool for manipulating and searching JSON in terminal pipelines.
    jq

    # A tool to show what file descriptors processes have open.
    lsof

    # A tool to bundle a nix package as a binary.
    nix-bundle

    # A small tool to dump info about the nix environment.
    nix-info

    # A tool to show info about nix builds.
    nix-output-monitor

    # A tool to review nixpkgs pull requests.
    nixpkgs-review

    # A (de)compressor for .7z files.
    # NOTE: This is the maintained fork, not the abandoned original p7zip.
    p7zip

    # A tool for applying patches.
    patch

    # A tool for binary patching ELF files and their library paths,
    # interpreters, etc.
    # This is useful for occasionally patching Steam games and other random
    # binaries to run outside of a FHS-y chroot.
    patchelf

    # A tool for inspecting binaries, including lddtree, an ldd-like tool that
    # shows what's loaded as a tree, without actually loading the binary and
    # potentially allowing arbitrary code execution like ldd.
    pax-utils

    # A modern ps-like tool written in Rust.
    procs

    # Various process and /proc utilities, such as kill, ps, uptime watch,,
    # etc.
    procps

    # Utilities for /proc, such as fuser, killall, etc.
    psmisc

    # A tool for helping with licensing projects.
    reuse

    # A tool for copying and backing up files and directories.
    rsync

    # A replacement tool similar to sed.
    sd

    # A tool like ack, but faster.
    silver-searcher

    # A tool for tracing system calls.
    strace

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
    util-linuxCurses

    # A utility for running commands when files in a directory change.
    watchman

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

  # Set ls's colors to solarized dark, and add in any custom colors.
  home.sessionVariables.LS_COLORS =
    let
      # Choose the dark solarized colors.
      # NOTE: This assumes the default terminal colors have been remapped to
      # solarized dark, but is more accurate than the 256-color approximation
      # version.
      solarized = "${inputs.dircolors-solarized}/dircolors.ansi-dark";

      # Compute the LS_COLORS ahead of time, since any color-capable terminal
      # should support these.
      solarized-colorfile = pkgs.runCommand "LS_COLORS" { } ''
        # Run strictly and die if anything fails.
        set -euo pipefail

        # Ensure we have a valid TERM set that is recognized by the color file.
        TERM=xterm
        export TERM

        # Make sure LS_COLORS isn't set.
        unset LS_COLORS

        # Eval the color file, which will dump the colors into this script.
        # NOTE: Replace this if I ever find a way to do this without eval.
        eval "$(${pkgs.coreutils}/bin/dircolors "${solarized}")"

        # Echo the colors as our output.
        echo "$LS_COLORS" > "$out"
      '';

      # Trim trailing newlines from the given string.
      trim = s: lib.removeSuffix "\n" s;

      # Read the computed colors as a string to skip having to cat it from
      # another file during variable initialization.
      solarized-colors = trim (builtins.readFile "${solarized-colorfile}");

      # Custom colors to add to the solarized colors.
      custom-colors = builtins.concatStringsSep ":" [
        "*.green=04;32"
      ];
    in
    "${solarized-colors}:${custom-colors}";

  # Various common shell aliases.
  home.shellAliases =
    let
      profileBin = "${config.home.profileDirectory}/bin";
    in
    {
      # Enable color for common tools when in a terminal that supports it.

      egrep = "${profileBin}/egrep --color=auto";
      fgrep = "${profileBin}/fgrep --color=auto";
      grep = "${profileBin}/grep --color=auto";

      # Use reflinks when able to to benefit from CoW filesystems.
      cp = "${profileBin}/cp --reflink=auto";
    };

  # A shiny alternative to ls written in rust.
  programs.eza.enable = true;

  # Enable the ls aliases.
  programs.eza.enableBashIntegration = true;
  programs.eza.enableZshIntegration = true;

  # Enable color when possible.
  programs.eza.colors = "auto";

  # Show icons and git status in exa.
  programs.eza.git = true;
  programs.eza.icons = "auto";

  programs.eza.extraOptions = [
    # Use binary prefixes for file sizes.
    "--binary"

    # Color file sizes based on how large they are.
    "--color-scale"

    # Show groups in the long listing.
    "--group"
  ];

  # A shiny alternative to find written in rust.
  programs.fd.enable = true;

  # A program to generate nix packages from URLs.
  programs.nix-init.enable = true;

  # A fast, featureful grep-like tool.
  programs.ripgrep.enable = true;

  # A process queue manager.
  services.pueue.enable = true;
}
