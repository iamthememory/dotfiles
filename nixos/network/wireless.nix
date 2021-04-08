# Wireless networking configuration.
{ ...
}: {
  # Enable wavemon, a tool for seeing the packet drop rate and other info for a
  # wifi interface.
  programs.wavemon.enable = true;
}
