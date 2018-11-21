{ pkgs, ... }:
with pkgs;
  let
    nixos = builtins.pathExists /etc/nixos/configuration.nix;
    optionals = lib.optionals;
  in
  # Networking.
  [
    aria2
    avahi
    dnsutils
    host
    metasploit
    nxBender
  ] ++ optionals (nixos) [
    chrony
    links
    megatools
    mosh
    mtr
    ngrep
    nmap
    socat
    sshfs
    telnet
    tmate
    tor
    torsocks
  ]
