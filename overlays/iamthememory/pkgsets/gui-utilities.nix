{ pkgs, ... }:
with pkgs;
  # Nice GUI utilities.
  [
    #baobab
    gnome3.gnome-disk-utility
    #libreoffice
    virtmanager
    xdotool
  ]
