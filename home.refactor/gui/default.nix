# Basic GUI setup.
{ config
, inputs
, lib
, pkgs
, ...
}: {
  imports = [
    ./dunst.nix
    ./fonts.nix
    ./kitty.nix
    ./locker.nix
  ];

  home.packages = with pkgs; [
    # Ensure dbus is available.
    dbus
  ];

  # Link dbus.socket into the systemd user directory to ensure it's started for
  # graphical sessions.
  home.activation.createDbusSocketLink = inputs.lib.mkSymlink {
    inherit lib;
    link = "${config.xdg.configHome}/systemd/user/graphical-session-pre.target.wants/dbus.socket";
    target = "${config.home.profileDirectory}/etc/systemd/user/dbus.socket";
  };

  # Use solarized dark colors for anything that reads xresources.
  xresources.extraConfig =
    let
      solarizedDark = "${inputs.xresources-solarized}/Xresources.dark";
    in
    builtins.readFile solarizedDark;

  # Use Literation Mono (Liberation Mono patched with NerdFont glyphs) as the
  # default xterm font.
  xresources.properties."XTerm.vt100.faceName" =
    "LiterationMono Nerd Font Mono:size=9:antialias=true";
}
