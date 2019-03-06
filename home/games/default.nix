{ config, lib, options, ... }:
let
  inherit (import ../hostid.nix) hostname hasGui hasGames;

  inherit (import ../channels.nix) unstable stable master;
  pkgs = unstable;
in
  {
    imports = lib.optionals hasGames [
      ./nethack.nix
    ] ++ lib.optionals (hasGames && hasGui) [
    ];

    home.packages = with pkgs; lib.optionals hasGames [
      cataclysm-dda-git
      scanmem
      tinyfugue
      ttyrec
    ] ++ lib.optionals (hasGames && hasGui) [
      cabextract
      discord
      dwarf-fortress-packages.dwarf-fortress-full
      ftb
      innoextract
      jre
      mcomix
      openrct2
      stable.playonlinux
      master.steam
      master.steam-run
      wineStaging
      winetricks
    ];
  }
