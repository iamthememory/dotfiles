# Add packages not in nixpkgs for installation.
# Additionally, customize some packages for home-manager that we can't specify
# a custom package for in home-manager itself.
self: super: {
  # Customize gnupg.
  gnupg = import ./gnupg.nix { inherit self super; };
}
