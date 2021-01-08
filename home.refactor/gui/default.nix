# Basic GUI setup.
{ config
, inputs
, lib
, pkgs
, ...
}: {
  imports = [
    ./dunst.nix
    ./fonts.nix
    ./kitty.nix
    ./locker.nix
  ];

  home.packages = with pkgs; [
    # Ensure dbus is available.
    dbus
  ];

  # Link dbus.socket into the systemd user directory to ensure it's started for
  # graphical sessions.
  home.activation.createDbusSocketLink = inputs.lib.mkSymlink {
    inherit lib;
    link = "${config.xdg.configHome}/systemd/user/graphical-session-pre.target.wants/dbus.socket";
    target = "${config.home.profileDirectory}/etc/systemd/user/dbus.socket";
  };

  # Ensure all programs share the same default dbus session, even if started via
  # something like cron or a systemd user unit.
  # FIXME: Maybe this shouldn't assume it should be in /run/user/<UID>?
  home.sessionVariables.DBUS_SESSION_BUS_ADDRESS =
    let
      # The path to the latest id in the profile.
      id = "${config.home.profileDirectory}/bin/id";

      # The real user ID at the time this is run.
      uid = "$(\"${id}\" --real --user)";
    in
    "unix:path=/run/user/${uid}/bus";

  # Settings to use when running most Java applications.
  home.sessionVariables._JAVA_OPTIONS =
    let
      options = [
        # Use font anti-aliasing, with RGB-style LCD subpixel hinting.
        "-Dawt.useSystemAAFontSettings=lcd"

        # Use a GTK look and feel by default, so Java programs look more natural
        # when around native programs.
        "-Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel"
      ];
    in
    builtins.concatStringsSep " " options;

  # Use solarized dark colors for anything that reads xresources.
  xresources.extraConfig =
    let
      solarizedDark = "${inputs.xresources-solarized}/Xresources.dark";
    in
    builtins.readFile solarizedDark;

  # Use Literation Mono (Liberation Mono patched with NerdFont glyphs) as the
  # default xterm font.
  xresources.properties."XTerm.vt100.faceName" =
    "LiterationMono Nerd Font Mono:size=9:antialias=true";
}
