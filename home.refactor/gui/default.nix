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
