# Printing configuration.
{ pkgs
, ...
}: {
  # Enable Avahi to discover printers on the local network.
  services.avahi.enable = true;

  # Allow resolving .local names on the local network via Avahi.
  services.avahi.nssmdns = true;

  # Enable CUPS.
  services.printing.enable = true;

  # Extra drivers to add to CUPS.
  services.printing.drivers = with pkgs; [
    # Add gutenprint drivers.
    gutenprint

    # Add better support for HP printers.
    hplip

    # Add better support for Samsung printers.
    splix
  ];
}
