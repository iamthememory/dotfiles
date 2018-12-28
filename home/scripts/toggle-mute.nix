{ pkgs, ... }:
let
  pamixer = "${pkgs.pamixer}/bin/pamixer";
in
  pkgs.writeScript "toggle-mute.sh" ''
    #!${pkgs.bash}/bin/bash

    # Toggle the mute status.

    if [ "$(${pamixer} --get-mute)" = "false" ]
    then
      ${pamixer} --mute
    else
      ${pamixer} --unmute
    fi
  ''
