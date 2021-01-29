# i3 configuration settings.
{ config
, inputs
, lib
, pkgs
, ...
}: {
  imports = [
    ./bindings.nix
  ];

  home.packages = with pkgs; [
    # Ensure dmenu is available.
    dmenu

    # Ensure i3 tools like i3-msg are available in the profile.
    i3
  ];

  # Enable i3.
  xsession.windowManager.i3.enable = true;

  # The default workspace names and assignments.
  xsession.windowManager.i3.config.assigns = lib.mkDefault {
    # Workspace for communication programs.
    "1:comm" = [
      # Put Discord here.
      { class = "^discord$"; }
    ];

    # Workspace for system things, such as hacking on system configuration and
    # updating.
    "2:sys" = [ ];

    # Workspace for email.
    "3:mail" = [ ];

    # Workspace for miscellaneous windows and browser tabs.
    "9:misc" = [ ];
  };

  # Don't move the mouse to the new window if switching focus between monitors.
  xsession.windowManager.i3.config.focus.mouseWarping = false;

  # The launcher to use.
  xsession.windowManager.i3.config.menu =
    let
      inherit (inputs.lib.solarized) colorNames;

      # The path to dmenu_run.
      dmenu_run = "${config.home.profileDirectory}/bin/dmenu_run";

      # The arguments to dmenu.
      dmenuArgs = builtins.concatStringsSep " " [
        # Use the same font we use for i3 and dunst, just with font size
        # specified how Fontconfig prefers it.
        "-fn 'LiterationMono Nerd Font Mono:size=9:antialias=true:autohint=true'"

        # The background color to use.
        "-nb '${colorNames.base03}'"

        # The normal text color.
        "-nf '${colorNames.base00}'"

        # The background for the current selection.
        "-sb '${colorNames.base01}'"

        # The text color for the current selection.
        "-sf '${colorNames.base1}'"

        # The prompt to show.
        "-p 'Run: '"
      ];
    in
    "${dmenu_run} ${dmenuArgs}";

  # The terminal to use.
  xsession.windowManager.i3.config.terminal =
    let
      # The profile binary directory.
      profileBin = "${config.home.profileDirectory}/bin";

      # i3's default terminal selector from the current profile.
      i3-sensible-terminal = "${profileBin}/i3-sensible-terminal";
    in
      config.home.sessionVariables.TERMINAL or i3-sensible-terminal;

  # Start new workspaces with a tabbed layout.
  xsession.windowManager.i3.config.workspaceLayout = "tabbed";
}
