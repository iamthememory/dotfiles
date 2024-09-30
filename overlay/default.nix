# Add packages not in nixpkgs for installation.
# Additionally, customize some packages for home-manager that we can't specify
# a custom package for in home-manager itself.
self: super: {
  # Customize appimage-run.
  appimage-run = import ./appimage-run.nix { inherit self super; };

  # Lower the priority of the nix-zsh-completions so packages providing their
  # own completions take priority.
  nix-zsh-completions = super.lib.setPrio 20 super.nix-zsh-completions;

  # Add the configuration for the 8BitDo Pro 2 controller.
  retroarch-joypad-autoconfig = super.retroarch-joypad-autoconfig.overrideAttrs {
    patches = [
      ./retroarch-8bitdo.patch
    ];
  };

  # Customize steam.
  steam = import ./steam.nix { inherit self super; };
}
