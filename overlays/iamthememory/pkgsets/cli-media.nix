{ pkgs, ... }:
with pkgs;
  # Media.
  [
    mpc_cli
    mpd
    mpv
    ncmpcpp
    playerctl
    sox
    youtube-dl
  ]
