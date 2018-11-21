{ pkgs, ... }:
with pkgs;
  let
    nixos = builtins.pathExists /etc/nixos/configuration.nix;
    optionals = lib.optionals;
  in
  # Nice utilities.
  [
    agrep
    bc
    bzip2
    coreutils
    curl
    ddrescue
    diceware
    dos2unix
    dosfstools
    dot2tex
    ffmpeg
    gnutar
    gptfdisk
    gzip
    htop
    iotop
    jq
    libisoburn
    lm_sensors
    manpages
    nox
    openssh
    pandoc
    pass
    pinfo
    posix_man_pages
    psmisc
    pv
    pwgen
    pydf
    python36Packages.glances
    squashfsTools
    texlive.combined.scheme-full
    tree
    ttyrec
    unrar
    unzip
    wget
    xar
    xz
  ] ++ optionals (nixos) [
    acct
    docker
    lsof
    mlocate
    zfs
  ]
