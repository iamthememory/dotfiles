{ pkgs, ... }:
with pkgs;
  # GUI games.
  [
    cabextract
    dwarf-fortress-packages.dwarf-fortress-full
    ftb
    innoextract
    jre
    openrct2
    playonlinux
    wineStaging
    winetricks
  ]
