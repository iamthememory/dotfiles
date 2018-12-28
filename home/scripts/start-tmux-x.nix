{ pkgs, ... }:
let
  st = "${pkgs.st}/bin/st";
  tmux = "${pkgs.tmux}/bin/tmux";
in
  pkgs.writeScript "start-tmux-x.sh" ''
    #!${pkgs.bash}/bin/bash

    # Start tmux in a terminal, attaching if it already exists.

    if ${tmux} has-session >/dev/null 2>/dev/null
    then
      exec ${st} -e ${tmux} attach
    else
      exec ${st} -e ${tmux} new
    fi
  ''
