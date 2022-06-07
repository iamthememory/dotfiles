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

  # The current profile's binary directory.
  profileBin = "${config.home.profileDirectory}/bin";
in
{
  home.packages = with pkgs; [
    # XIVLauncher.
    xivlauncher
  ];

  # Make ACT always floating.
  xsession.windowManager.i3.config.floating.criteria = [
    { class = "[Aa]dvanced [Cc]ombat [Tt]racker"; }
  ];

  # Start FFXIV.
  xsession.windowManager.i3.config.keybindings."${mod}+Control+Shift+f" =
    "exec ${profileBin}/XIVLauncher.Core";

  # Disable window borders for FFXIV.
  xsession.windowManager.i3.config.window.commands = [
    {
      command = "border none";
      criteria = { instance = "^ffxiv(|_dx11)\\.exe$"; };
    }
  ];

  # Don't automatically focus ACT windows, since they might be overlays that
  # grab the mouse mid-fight.
  xsession.windowManager.i3.extraConfig = ''
    no_focus [class="[Aa]dvanced [Cc]ombat [Tt]racker"]
  '';
}
