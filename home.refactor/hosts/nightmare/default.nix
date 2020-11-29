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
    ../../utils
    ../../zsh
    ../../zsh/zsh-auto-notify.nix
  ];
}
