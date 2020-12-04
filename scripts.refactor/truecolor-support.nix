{
  pkgs,
  ...
}: rec {
  # If a set has an outPath it can be coerced to a string.
  # We take advantage of that to write the script so it can be used easily as a
  # utility, and be installed if desired.
  bin = pkgs.writeShellScriptBin "truecolor-support.sh" ''
    if [ "$TERMCOLOR" = "truecolor" ] || [ "$TERMCOLOR" = "24bit" ]
    then
      # If the terminal says we have truecolor, may as well believe it.
      echo yes
    elif [ "$(${pkgs.ncurses}/bin/tput colors 2>/dev/null)" -gt 256 ]
    then
      # Ncurses seems to think we have truecolor, so we probably do.
      echo yes
    elif [[ "$TERM" =~ ^kitty([+-].*)? ]] || [[ "$TERM" =~ ^xterm-kitty.* ]]
    then
      # Kitty always has truecolor, but its terminfo is missing in older
      # ncurses, and doesn't match the terminfo in upstream kitty in confusing
      # ways, so just force truecolor since it should have it anyway.
      echo yes
    else
      echo no
    fi
  '';

  outPath = "${bin}/bin/truecolor-support.sh";
}
