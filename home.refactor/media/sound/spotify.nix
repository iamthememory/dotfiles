# Configuration for Spotify.
{ config
, pkgs
, ...
}:
let
  # The i3 modifier key.
  mod = config.xsession.windowManager.i3.config.modifier;

  # The binary directory of the current profile.
  profileBin = "${config.home.profileDirectory}/bin";
in
{
  home.packages = with pkgs; [
    # A tool to control media players over DBUS.
    playerctl

    # Spotify.
    spotify
  ];

  # Make Spotify always a floating window.
  xsession.windowManager.i3.config.floating.criteria = [
    { class = "^Spotify$"; }
  ];

  # Start Spotify when i3 starts.
  xsession.windowManager.i3.config.startup = [
    { command = "${profileBin}/spotify"; }
  ];

  # i3 keybindings for Spotify control.
  xsession.windowManager.i3.config.keybindings = {
    # Skip to the next song.
    "XF86AudioNext" = "exec ${profileBin}/playerctl --player=spotify next";

    # Toggle play/pause.
    "XF86AudioPause" = "exec ${profileBin}/playerctl --player=spotify play-pause";

    # Toggle play/pause.
    "XF86AudioPlay" = "exec ${profileBin}/playerctl --player=spotify play-pause";

    # Go back to the previous song.
    "XF86AudioPrev" = "exec ${profileBin}/playerctl --player=spotify previous";


    # Show Spotify from the scratchpad.
    "${mod}+equal" = "[class=\"^Spotify$\"] scratchpad show";


    # Skip to the next song.
    "${mod}+Control+n" = "exec ${pkgs.playerctl}/bin/playerctl --player=spotify next";

    # Go back to the previous song.
    "${mod}+Control+p" = "exec ${pkgs.playerctl}/bin/playerctl --player=spotify previous";
  };

  # Put Spotify's GUI on the scratchpad.
  xsession.windowManager.i3.extraConfig = ''
    for_window [class="^Spotify$"] move scratchpad
  '';
}
