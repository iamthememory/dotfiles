# Configuration for various utilities and terminal niceties.
{ pkgs
, ...
}: {
  # Extra packages to install system-wide.
  # These are mostly niceties that are useful to have in a root shell.
  environment.systemPackages = with pkgs; [
    # A script-friendly HTTP(S), etc. utility.
    curlFull

    # A way of identifying file types, MIMEs, etc.
    file

    # A nice ncurses top-like utility.
    htop

    # A tool to read sensors and get CPU and other temperatures.
    lm_sensors

    # An editor.
    vim

    # An easy HTTP(S), etc. fetcher.
    wget
  ];

  # Enable iotop, a way of monitoring processes doing the most IO.
  programs.iotop.enable = true;

  # Enable the less pager.
  programs.less.enable = true;

  # Enable usbtop, a top-like utility for USB IO.
  programs.usbtop.enable = true;

  # Enable zsh as an interactive shell option.
  programs.zsh.enable = true;
}
