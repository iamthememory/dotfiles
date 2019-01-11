{ config, pkgs, ... }:
let
  date = "${pkgs.coreutils}/bin/date";
  flameshot = "${pkgs.flameshot}/bin/flameshot";
  homedir = config.home.homeDirectory;
in
  pkgs.writeScript "take-screenshot.sh" ''
    #!${pkgs.bash}/bin/bash

    screendir="$(${date} "+${homedir}/screenshots/%Y/%m")"

    if [ ! -e "$screendir" ]
    then
      mkdir -pv "$screendir"
    fi

    exec ${flameshot} gui -p "$screendir"
  ''
