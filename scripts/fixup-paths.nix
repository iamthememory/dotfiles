{ pkgs
, ...
}: rec {
  # If a set has an outPath it can be coerced to a string.
  # We take advantage of that to write the script so it can be used easily as a
  # utility, and be installed if desired.
  bin = pkgs.writeShellScriptBin "fixup-paths.sh" ''
    echo "$1" \
      | ${pkgs.coreutils}/bin/tr ':' '\n' \
      | ${pkgs.gawk}/bin/gawk '!x[$0]++' \
      | ${pkgs.gnugrep}/bin/grep -E '^/' \
      | ${pkgs.coreutils}/bin/tr '\n' ':' \
      | ${pkgs.gnused}/bin/sed -r 's@^:+@@;s@:+$@@'
  '';

  outPath = "${bin}/bin/fixup-paths.sh";
}
