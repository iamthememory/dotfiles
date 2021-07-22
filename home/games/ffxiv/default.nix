# FFXIV-related configuration.
{ config
, inputs
, lib
, pkgs
, ...
}:
let
  # The i3 modifier key.
  mod = config.xsession.windowManager.i3.config.modifier;

  # The WINE to use for FFXIV.
  ffxivWine = inputs.lib.wine.mkWine {
    inherit pkgs;

    src = inputs.lutris-6_5;
    version = "lutris-6.5";
  };

  # The current profile's binary directory.
  profileBin = "${config.home.profileDirectory}/bin";

  # The FFXIV base directory.
  ffxivDirectory = config.home.sessionVariables.FFXIV_DIRECTORY;

  # The directory to put the patched WINE.
  patchedWineDirectory = "${ffxivDirectory}/patched-wine";

  # The WINE prefix for FFXIV.
  winePrefix = "${ffxivDirectory}/pfx";

  # The link to the unpatched WINE for checking if it needs to be re-setuided.
  unpatchedWineLink = "${ffxivDirectory}/unpatched-wine";

  # The FFXIV WINE wrapper.
  ffxivWineWrapper = pkgs.writeShellScriptBin "ffxiv-wine.sh" ''
    # Die on errors.
    set -euo pipefail

    # Enable an overlay for FPS and frame draw times.
    export DXVK_HUD=fps,frametimes

    # Increase the Pulseaudio latency to prevent crackling.
    export PULSE_LATENCY_MSEC=100

    # Increase the realtime priority the wineserver itself uses to decrease
    # latency.
    # This shouldn't give actual programs realtime privileges, just the
    # managing WINE server.
    export STAGING_RT_PRIORITY_SERVER=50

    # Use shared memory to improve some calls.
    export STAGING_SHARED_MEMORY=1

    # The WINE to run.
    export WINE="${patchedWineDirectory}/bin/wine64"

    # Disable WINE debugging.
    export WINEDEBUG=-all

    # Enable WINE ESYNC and FSYNC.
    export WINEESYNC=1
    export WINEFSYNC=1

    # The WINE prefix to use.
    export WINEPREFIX="${winePrefix}"

    # Force WINE to be large address aware, and allow 32-bit programs access
    # to more RAM.
    export WINE_LARGE_ADDRESS_AWARE=1

    # Exec WINE.
    exec "''${WINE}" "$@"
  '';

  # A script to start FFXIV.
  start-ffxiv = pkgs.writeShellScriptBin "start-ffxiv.sh" ''
    # Die on errors.
    set -euo pipefail

    # Run FFXIV's launcher.
    exec \
      "${profileBin}/ffxiv-wine.sh" \
      "${winePrefix}/drive_c/Program Files (x86)/SquareEnix/FINAL FANTASY XIV - A Realm Reborn/boot/ffxivboot.exe"
  '';
in
{
  home.packages = with pkgs; [
    # The FFXIV WINE wrapper.
    ffxivWineWrapper

    # A wrapper to start FFXIV.
    start-ffxiv
  ];

  # Check if we have a new patched WINE, and if so, replace the current WINE
  # with it.
  home.activation.updateFFXIVWine =
    let
      # The path to various tools.
      chown = "${pkgs.coreutils}/bin/chown";
      gksudo = "${pkgs.gksu}/bin/gksudo";
      ln = "${pkgs.coreutils}/bin/ln";
      realpath = "${pkgs.coreutils}/bin/realpath";
      rm = "${pkgs.coreutils}/bin/rm";
      rsync = "${pkgs.rsync}/bin/rsync";
      setcap = "${pkgs.libcap}/bin/setcap";

      # A script to patch WINE.
      patchWine = pkgs.writeShellScript "newwine.sh" ''
        # Die on failure.
        set -euo pipefail

        # Sync the unpatched WINE and delete anything else.
        ${rsync} -aHAXSc --delete "$1/" "$2/"

        # Set the new WINE ownership to root.
        ${chown} -hR root:root "$2"

        # Set the proper permissions on WINE binaries for ACT to be able to
        # work.
        ${setcap} cap_net_raw,cap_net_admin,cap_sys_ptrace=eip "$2/bin/wine"
        ${setcap} cap_net_raw,cap_net_admin,cap_sys_ptrace=eip "$2/bin/wine64"
        ${setcap} cap_sys_nice,cap_net_raw,cap_net_admin,cap_sys_ptrace=eip "$2/bin/wineserver"
      '';
    in
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      HM_DO_FFXIV_WINE_UPDATE=0

      if [ ! -L "${unpatchedWineLink}" ] || [ ! -d "${patchedWineDirectory}" ]
      then
        $VERBOSE_ECHO "FFXIV WINE unpatched info or patched WINE missing: Updating FFXIV WINE"
        HM_DO_FFXIV_WINE_UPDATE=1
      elif [ "$(${realpath} "${unpatchedWineLink}")" != "$(${realpath} ${ffxivWine})" ]
      then
        $VERBOSE_ECHO "FFXIV WINE unpatched info doesn't match new WINE: Updating FFXIV WINE"
        HM_DO_FFXIV_WINE_UPDATE=1
      else
        $VERBOSE_ECHO "FFXIV WINE seems to match: Not updating FFXIV WINE"
      fi

      if [ "$HM_DO_FFXIV_WINE_UPDATE" = "1" ]
      then
        $DRY_RUN_CMD ${gksudo} -- ${patchWine} ${ffxivWine} "${patchedWineDirectory}"
        $DRY_RUN_CMD ${rm} -f "${unpatchedWineLink}"
        $DRY_RUN_CMD ${ln} -s ${ffxivWine} "${unpatchedWineLink}"
      fi

      unset HM_DO_FFXIV_WINE_UPDATE
    '';

  # Make ACT always floating.
  xsession.windowManager.i3.config.floating.criteria = [
    { class = "[Aa]dvanced [Cc]ombat [Tt]racker"; }
  ];

  # Start FFXIV.
  xsession.windowManager.i3.config.keybindings."${mod}+Control+Shift+f" =
    "exec ${profileBin}/start-ffxiv.sh";

  # Disable window borders for FFXIV.
  xsession.windowManager.i3.config.window.commands = [
    {
      command = "border none";
      criteria = { instance = "^ffxiv(|_dx11)\\.exe$"; };
    }
  ];

  # Put ACT on the scratchpad.
  xsession.windowManager.i3.extraConfig = ''
    for_window [class="[Aa]dvanced [Cc]ombat [Tt]racker"] move scratchpad
  '';
}
