{ pkgs, ... }:
with pkgs;
  let
    nixos = builtins.pathExists /etc/nixos/configuration.nix;
    optionals = lib.optionals;
    gui-fonts = import ./gui-fonts.nix { inherit pkgs; };
  in
  # Basic GUI packages.
  [
    blueman
    dmenu
    dunst
    gnome3.adwaita-icon-theme
    gnome3.nautilus
    gnome3.networkmanagerapplet
    gnome3.seahorse
    gnome3.zenity
    i3pystatus
    ibus
    ibus-engines.anthy
    ibus-engines.table
    ibus-engines.table-others
    kbfs
    keybase-gui
    libnotify
    numlockx
    pamixer
    pavucontrol
    pngcrush
    redshift
    scrot
    solaar
    st
    system-config-printer
    unclutter-xfixes
    x11_ssh_askpass
    xclip
    xcompmgr
    xorg.xdpyinfo
    xorg.xkill
    xorg.xmodmap
    xss-lock
  ] ++ optionals (nixos) [
    gksu
    i3
    i3lock
    lightdm
    lightdm_gtk_greeter
  ] ++ gui-fonts
