# Basic GUI setup.
{ config
, inputs
, lib
, pkgs
, ...
}: {
  imports = [
    ./browser
    ./display.nix
    ./dunst.nix
    ./fonts.nix
    ./keyring.nix
    ./kitty.nix
    ./i3
    ./input.nix
    ./locker.nix
    ./st
  ];

  home.packages = with pkgs; [
    # A tool for seeing disk space usage.
    baobab

    # Add blueman to the packages.
    blueman

    # Ensure coreutils is available.
    coreutils

    # Ensure dbus is available.
    dbus

    # The dconf tool for reading the GTK-y settings that aren't stored in
    # program-specific files.
    dconf

    # The GUI dconf editor.
    gnome.dconf-editor

    # A tool for managing disks and easily seeing SMART data.
    gnome.gnome-disk-utility

    # The nautilus file browser.
    gnome.nautilus

    # The NetworkManager applet.
    networkmanagerapplet

    # A tool for controlling Logitech receivers to, e.g., pair them with new
    # mice and keyboards.
    solaar

    # A tool for manipulating the X11 clipboard.
    xclip

    # A tool for automated input in X11.
    xdotool

    # A tool for showing info about the X11 server.
    xorg.xdpyinfo

    # A tool for seeing X11 events such as keyboard input.
    xorg.xev

    # Tools for getting X11 window info.
    xorg.xprop
    xorg.xwininfo

    # A tool for telling how long the X11 user has been idle.
    xprintidle
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

  # Enable the NVIDIA shader cache.
  home.sessionVariables.__GL_SHADER_DISK_CACHE = 1;

  # Store the NVIDIA shader cache in the newer default location.
  home.sessionVariables.__GL_SHADER_DISK_CACHE_PATH =
    "${config.xdg.cacheHome}/nvidia/GLCache";

  # Enable a relatively large shader cache of 16 gigabytes.
  home.sessionVariables.__GL_SHADER_DISK_CACHE_SIZE = 16 * 1024 * 1024 * 1024;

  # Enable the blueman applet for bluetooth.
  services.blueman-applet.enable = true;

  # Enable KDE connect and its tray icon.
  services.kdeconnect.enable = true;
  services.kdeconnect.indicator = true;

  # Enable the Network Manager applet.
  services.network-manager-applet.enable = true;

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

  # Enable managing the X11 session.
  xsession.enable = true;

  # Extra things to run when starting the X11 session.
  xsession.initExtra = ''
    # Redirect output to /dev/null, since anything started via i3 dumps its
    # output to these file descriptors, flooding the journal if any GUI programs
    # are particularly verbose.
    exec >/dev/null
    exec 2>/dev/null
  '';
}
