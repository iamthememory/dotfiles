{
  config,
  lib,
  options,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ../../base.nix
    ../../gnupg.nix
    ../../utils
    ../../zsh
    ../../zsh/zsh-auto-notify.nix
  ];

  # Select the default gpg signing subkey.
  programs.gpg.settings.default-key = "0x34915A26CE416A5CDF500247D226B54765D868B7";

  # Use a GUI pinentry.
  services.gpg-agent.pinentryFlavor = "gtk2";
}
