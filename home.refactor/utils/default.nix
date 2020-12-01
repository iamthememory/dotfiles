# Basic terminal utilities and niceties helpful for most systems.
{
  inputs,
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
    ./bat.nix
    ./direnv.nix
    ./doc.nix
    ./fzf.nix
    ./hardware.nix
    ./media.nix
    ./net.nix
    ./nix-index.nix
    ./pazi.nix
    ./scripting.nix
    ./tui
  ];

  home.packages = with pkgs; [
    # A basic terminal calculator useful for some scripting.
    bc

    # Some low-level binary utilities such as nm, objdump, readelf, strings,
    # strip, etc.
    binutils

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

  # Set ls's colors to solarized dark, and add in any custom colors.
  home.sessionVariables.LS_COLORS = let
    # Choose the 256 color solarize dark colors.
    solarized = "${inputs.dircolors-solarized}/dircolors.256dark";

    # Compute the LS_COLORS ahead of time, since any color-capable terminal
    # should support these.
    solarized-colorfile = pkgs.runCommand "LS_COLORS" {} ''
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
    trim = s: pkgs.lib.removeSuffix "\n" s;

    # Read the computed colors as a string to skip having to cat it from
    # another file during variable initialization.
    solarized-colors = trim (builtins.readFile "${solarized-colorfile}");

    # Custom colors to add to the solarized colors.
    custom-colors = builtins.concatStringsSep ":" [
      "*.green=04;32"
    ];
  in "${solarized-colors}:${custom-colors}";

  # Add the common shell aliases for all shells.
  # NOTE: These will have no effect unless the relevant shell is enabled.
  programs.bash.shellAliases = shellAliases;
  programs.fish.shellAliases = shellAliases;
  programs.zsh.shellAliases = shellAliases;
}
