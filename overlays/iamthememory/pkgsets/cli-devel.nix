{ pkgs, ... }:
with pkgs;
  let
    nixos = builtins.pathExists /etc/nixos/configuration.nix;
    optionals = lib.optionals;
  in
  # Development tools.
  [
    ack
    ag
    bumpversion
    cloc
    cookiecutter
    ctags
    graphviz
    shellcheck
    strace
  ] ++ optionals (nixos) [
    linuxPackages.systemtap
  ]
