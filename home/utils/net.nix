# Basic network utilities and niceties.
{ pkgs
, ...
}: {
  imports = [
    # Ensure our SSH configuration is available.
    ../ssh.nix
  ];

  home.packages = with pkgs; [
    # A versatile fetcher for HTTP(S), FTP, torrents, etc.
    aria2

    # DNS utilities such as dig.
    bind.dnsutils

    # The host command.
    bind.host

    # A script-friendly HTTP(S), etc. utility.
    curlFull

    # A modern dig-like tool.
    dogdns

    # A human and script-friendly HTTP(S) utility.
    httpie

    # Various standard network programs.
    inetutils
    iproute2
    iputils

    # Tools for uploading/downloading files from/to MEGA.
    megatools

    # An ssh-like remote shell for unreliable connections.
    mosh

    # An enhanced traceroute utility.
    mtr

    # Various nix prefetchers to fetch URLs to the nix store and output their
    # hashes.
    nix-prefetch
    nix-prefetch-git
    nix-prefetch-github

    # A tool for doing cat-like operations over sockets.
    socat

    # Mount a remote directory using FUSE over SSH.
    sshfs

    # A terminal sharing utility based on tmux and ssh.
    tmate

    # A tool for seeing WiFi status, such as dropped packet rates, signal
    # strength, etc.
    wavemon

    # An easy HTTP(S), etc. fetcher.
    wget

    # A newer, not quite compatible version of wget.
    wget2

    # A fetcher for videos from various sites for archiving or local playback.
    youtube-dl
  ];
}
