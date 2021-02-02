# Add packages not in nixpkgs for installation.
# Additionally, customize some packages for home-manager that we can't specify
# a custom package for in home-manager itself.
self: super: {
  # Customize appimage-run.
  appimage-run = import ./appimage-run.nix { inherit self super; };

  # Customize gnupg.
  gnupg = import ./gnupg.nix { inherit self super; };

  # Patch and customize git and its packages.
  gitAndTools = import ./gitAndTools.nix { inherit self super; };
}
