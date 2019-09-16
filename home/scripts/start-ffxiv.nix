{ pkgs, ... }:
pkgs.writeScript "start-ffxiv.sh" ''
  #!${pkgs.bash}/bin/bash

  PROTON_PATH=$${HOME}/.local/share/Steam/compatibilitytools.d/proton-4.2-ffxiv
  LD_LIBRARY_PATH="$${PROTON_PATH}/dist/lib64:$${PROTON_PATH}/dist/lib"
  WINEPREFIX=/opt/steam/steamapps/compatdata/39210/pfx
  WINE="$${PROTON_PATH}/dist/bin/wine64"

  export LD_LIBRARY_PATH WINE WINEPREFIX

  exec ${pkgs.steam-run}/bin/steam-run "$${PROTON_PATH}/dist/bin/wine64" '/opt/steam/steamapps/compatdata/39210/pfx/drive_c/Program Files (x86)/SquareEnix/FINAL FANTASY XIV - A Realm Reborn/boot/ffxivboot.exe'
''
