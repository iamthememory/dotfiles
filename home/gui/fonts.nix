{ config, lib, options, ... }:
let
  inherit (import ../channels.nix) unstable;
in
  {
    # Discover fonts installed via nix-env too.
    fonts.fontconfig.enable = true;

    # Add some font packages.
    home.packages = with unstable; [
      corefonts
      dejavu_fonts
      ipafont
      league-of-moveable-type
      liberation_ttf
      nerdfonts
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      noto-fonts-extra
      powerline-fonts
    ];
  }
