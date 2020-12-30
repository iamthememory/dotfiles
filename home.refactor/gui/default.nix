# Basic GUI setup.
{ ...
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
}
