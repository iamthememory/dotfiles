{
  config,
  lib,
  options,
  pkgs,
  inputs,
  ...
}: {
  home.packages = [
    inputs.unstable.nixFlakes
  ];

  home.stateVersion = "20.09";
}
