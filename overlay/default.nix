# Add packages not in nixpkgs for installation.
# Additionally, customize some packages for home-manager that we can't specify
# a custom package for in home-manager itself.
self: super: {
  # Customize appimage-run.
  appimage-run = import ./appimage-run.nix { inherit self super; };

  # Customize steam.
  steam = import ./steam.nix { inherit self super; };
}
