# Steam and related configuration.
{ config
, pkgs
, ...
}: {
  home.packages = with pkgs; [
    # A winetricks wrapper that can run winetricks on Steam game prefixes
    # easily.
    protontricks

    # A wrapper for Steam games.
    steamtinkerlaunch
  ];

  # Start Steam on startup.
  xsession.windowManager.i3.config.startup = [
    { command = "/run/current-system/sw/bin/steam"; }
  ];
}
