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
    # Show Spotify from the scratchpad.
    "${mod}+equal" = "[class=\"^Spotify$\"] scratchpad show";
  };

  # Put Spotify's GUI on the scratchpad.
  xsession.windowManager.i3.extraConfig = ''
    for_window [class="^Spotify$"] move scratchpad
  '';
}
