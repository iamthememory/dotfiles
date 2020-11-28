# Basic network utilities and niceties.
{
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    # A versatile fetcher for HTTP(S), FTP, torrents, etc.
    aria2

    # DNS utilities such as dig.
    bind.dnsutils

    # The host command.
    bind.host

    # A script-friendly HTTP(S), etc. utility.
    curl

    # A human and script-friendly HTTP(S) utility.
    httpie

    # Various standard network programs.
    iproute
    iputils
    nettools

    # An ssh-like remote shell for unreliable connections.
    mosh

    # An enhanced traceroute utility.
    mtr

    # Various nix prefetchers to fetch URLs to the nix store and output their
    # hashes.
    nix-prefetch
    nix-prefetch-git
    nix-prefetch-github

    # SSH.
    openssh

    # Mount a remote directory using FUSE over SSH.
    sshfs

    # A terminal sharing utility based on tmux and ssh.
    tmate

    # An easy HTTP(S), etc. fetcher.
    wget

    # A fetcher for videos from various sites for archiving or local playback.
    youtube-dl
  ];
}
