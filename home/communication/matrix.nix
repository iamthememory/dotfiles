# Matrix-related configuration.
{ config
, lib
, pkgs
, ...
}:
let
  # The binary directory of the current profile.
  profileBin = "${config.home.profileDirectory}/bin";
in
{
  # Enable element-desktop.
  programs.element-desktop.enable = true;

  # The package to use.
  programs.element-desktop.package = pkgs.element-desktop.override {
    commandLineArgs = lib.strings.concatStringsSep " " [
      # Don't set the renderer to low priority.
      "--disable-renderer-backgrounding"

      # Use libsecret.
      "--password-store=gnome-libsecret"
    ];
  };

  # Start Element on startup.
  xsession.windowManager.i3.config.startup = [
    { command = "${profileBin}/element-desktop"; }
  ];
}
