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
  ];
}
