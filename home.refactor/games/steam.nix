# Steam and related configuration.
{ config
, pkgs
, ...
}: {
  home.packages = with pkgs; [
    # A winetricks wrapper that can run winetricks on Steam game prefixes
    # easily.
    protontricks

    # Steam.
    steam
  ];

  # Start Steam on startup.
  xsession.windowManager.i3.config.startup = [
    { command = "${config.home.profileDirectory}/bin/steam"; }
  ];
}
