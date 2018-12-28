{ pkgs, ... }:
pkgs.writeScript "fixup-paths.sh" ''
  #!${pkgs.bash}/bin/bash

  echo "$1" \
    | ${pkgs.coreutils}/bin/tr ':' '\n' \
    | ${pkgs.gawk}/bin/gawk '!x[$0]++' \
    | ${pkgs.gnugrep}/bin/grep -E '^/' \
    | ${pkgs.coreutils}/bin/tr '\n' ':' \
    | ${pkgs.gnused}/bin/sed -r 's@^:+@@;s@:+$@@'
''
