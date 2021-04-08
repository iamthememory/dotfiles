# GUI configuration.
{ lib
, pkgs
, ...
}: {
  # Enable dconf.
  programs.dconf.enable = true;

  # Enable the Chromium SUID sandbox helper.
  # This lets Chromium, Chrome, electron, etc. sandbox itself.
  security.chromiumSuidSandbox.enable = true;

  # Enable GNOME keyring.
  services.gnome3.gnome-keyring.enable = true;

  # Enable flatpaks.
  services.flatpak.enable = true;

  # Enable geoclue2 for getting rough location information.
  services.geoclue2.enable = lib.mkDefault true;

  # Enable GVfs.
  services.gvfs.enable = true;

  # Enable Bolt for managing Thunderbolt security levels.
  services.hardware.bolt.enable = true;

  # Show smartd notifications on the default X11 display.
  services.smartd.notifications.x11.enable = true;

  # Enable X11.
  services.xserver.enable = true;

  # Enable lightdm as the display manager.
  services.xserver.displayManager.lightdm.enable = true;

  # Enable the GTK lightdm greeter.
  services.xserver.displayManager.lightdm.greeters.gtk.enable = true;

  # Set the clock format in lightdm.
  services.xserver.displayManager.lightdm.greeters.gtk.clock-format =
    "%a %Y-%m-%d %H:%M:%S";

  # Use the US keyboard layout.
  services.xserver.layout = "us";

  # Enable libinput.
  services.xserver.libinput.enable = true;

  # Enable i3wm.
  services.xserver.windowManager.i3.enable = true;

  # Enable XDG portals.
  xdg.portal.enable = true;

  # Extra portals to add.
  xdg.portal.extraPortals = with pkgs; [
    # The GTK desktop portal backend.
    xdg-desktop-portal-gtk
  ];
}
