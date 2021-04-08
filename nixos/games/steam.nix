# Steam configuration for NixOS.
{ ...
}: {
  # Enable Steam.
  # This should be done here, rather than in home-manager, as it enables things
  # Steam needs, such as all the OpenGL packages needed, Steam hardware udev
  # rules, and inserts the OpenGL and Vulkan drivers into Steam's FHS
  # environment, ensuring that pressure vessel picks them up, enabling pressure
  # vessel and the latest proton work properly.
  programs.steam.enable = true;
}
