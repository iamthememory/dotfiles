# Bluetooth configuration.
{ pkgs
, ...
}: {
  # Enable bluetooth.
  hardware.bluetooth.enable = true;

  # Enable blueman.
  services.blueman.enable = true;
}
