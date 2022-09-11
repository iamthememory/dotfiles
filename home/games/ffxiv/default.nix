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
  home.packages =
    let
      # The xivlauncher versions in order of preference.
      xivlaunchers = [
        { pkg = pkgs.xivlauncher; source = "pkgs"; priority = 2; }
        { pkg = inputs.unstable.xivlauncher; source = "unstable"; priority = 1; }
        { pkg = inputs.master.xivlauncher; source = "master"; priority = 0; }
      ];

      # A function to sort by version, then priority.
      # This returns whether a should be preferred over b.
      versionCompare = a: b:
        let
          versionComparison = builtins.compareVersions a.pkg.version b.pkg.version;
        in
        if versionComparison == 0
        then
          a.priority > b.priority
        else
          versionComparison == 1;

      # Pick whichever xivlauncher is best.
      xivlauncher =
        let
          xiv = builtins.elemAt (lib.sort versionCompare xivlaunchers) 0;
          traceMsg = "Using xivlauncher version " + xiv.pkg.name + " from " + xiv.source + ".";
        in
        builtins.trace traceMsg xiv.pkg;
    in
    [
      # XIVLauncher.
      xivlauncher
    ];

  # Make ACT always floating.
  xsession.windowManager.i3.config.floating.criteria = [
    {
      class = "[Aa]dvanced [Cc]ombat [Tt]racker";
    }
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
