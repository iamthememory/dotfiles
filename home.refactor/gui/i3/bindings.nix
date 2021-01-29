# Keybinding settings for i3.
{ config
, inputs
, lib
, pkgs
, ...
}:
let
  # The modifier key.
  mod = config.xsession.windowManager.i3.config.modifier;

  # The binary directory of the current profile.
  profileBin = "${config.home.profileDirectory}/bin";

  # All workspace keybindings.
  workspaceBindings =
    let
      inherit (builtins) attrNames;

      # All of the workspace names that're defined.
      names = attrNames config.xsession.windowManager.i3.config.assigns;

      # All workspace numbers, 1 to 10.
      numbers = builtins.genList (x: builtins.toString (x + 1)) 10;

      # Given a workspace number, get the workspace name.
      getName = number:
        let
          # Abort if multiple of the given workspace number exist.
          doAbort =
            builtins.abort
              "Multiple i3 workspaces defined with prefix '${number}:'";

          # Check whether the given workspace name matches the workspace number
          # by prefix or whole string, e.g., workspace 1 matches "1" or "1:...".
          hasNumber = x:
            x == "${number}" || (lib.hasPrefix "${number}:" x);

          # Return the plain workspace number if the given workspace isn't
          # defined with a specific name.
          default = "${number}";
        in
        lib.findSingle hasNumber default doAbort names;

      # All workspaces as a map from numbers to their names.
      workspaceNames = lib.genAttrs numbers getName;

      # Get the key for a given workspace.
      # This gives back the same key, but returns 0 for 10.
      getWorkspaceKey = k: if k == "10" then "0" else k;

      # Keybindings to switch workspaces.
      switchBindings = lib.mapAttrs'
        (n: v: {
          name = "${mod}+${getWorkspaceKey n}";
          value = "workspace number ${v}";
        })
        workspaceNames;

      # Keybindings to move things between workspaces.
      moveBindings = lib.mapAttrs'
        (n: v: {
          name = "${mod}+Shift+${getWorkspaceKey n}";
          value = "move container to workspace number ${v}";
        })
        workspaceNames;
    in
    switchBindings // moveBindings;

  # Formatting arguments to dmenu.
  dmenuArgs =
    let
      inherit (inputs.lib.solarized) colorNames;
    in
    builtins.concatStringsSep " " [
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
    ];

  # The passmenu to use for copying/typing passwords from the password store.
  passmenu =
    let
      # The path to passmenu.
      passmenu = "${profileBin}/passmenu";
    in
    "${passmenu} ${dmenuArgs} -p 'Pass: '";

  # The i3-dmenu-desktop to run.
  i3-dmenu-desktop =
    let
      # The path to i3-dmenu-desktop.
      i3-dmenu-desktop = "${profileBin}/i3-dmenu-desktop";
    in
    "${i3-dmenu-desktop} ${dmenuArgs} -p 'Run: '";
in
{
  imports = [
    # Ensure pass is available.
    ../../pass.nix

    # Ensure htop is available.
    ../../utils/tui/htop.nix

    # Ensure autorandr is available.
    ../display.nix

    # Ensure fonts are available.
    ../fonts.nix

    # Ensure the locker is available.
    ../locker.nix
  ];

  home.packages = with pkgs; [
    # Ensure coreutils is available.
    coreutils

    # Ensure nautilus is available.
    gnome3.nautilus

    # Ensure loginctl is available.
    systemd

    # Ensure xkill is available for forcibly killing a window.
    xorg.xkill

    # Ensure xset is available for locking the screen.
    xorg.xset
  ];

  # Use Mod1 (left ALT) as the default modifier.
  xsession.windowManager.i3.config.modifier = "Mod1";

  # The i3 keybindings.
  xsession.windowManager.i3.config.keybindings = {
    # Spawn a terminal.
    "${mod}+Return" =
      "exec ${config.xsession.windowManager.i3.config.terminal}";


    # Switch focus between tiled and floating windows.
    "${mod}+space" = "focus mode_toggle";

    # Switch a window between tiled and floating mode.
    "${mod}+Shift+space" = "floating toggle";


    # Show a window from the scratchpad.
    "${mod}+minus" = "scratchpad show";

    # Move a window to the scratchpad.
    "${mod}+Shift+minus" = "move scratchpad";


    # Focus on the parent container.
    "${mod}+a" = "focus parent";

    # Select a password and type it into the current window.
    "${mod}+Shift+a" = "exec ${passmenu} --type";

    # Select a password and insert it into the clipboard.
    "${mod}+Control+a" = "exec ${passmenu}";


    # Focus on the child container.
    "${mod}+c" = "focus child";

    # Run a browser.
    "${mod}+Control+c" = "exec ${config.home.sessionVariables.BROWSER}";

    # Run a browser in private/incognito mode.
    "${mod}+Control+Shift+c" =
      "exec ${config.home.sessionVariables.BROWSER_PRIVATE}";


    # Run an arbitrary binary from the menu.
    "${mod}+d" = "exec ${config.xsession.windowManager.i3.config.menu}";

    # Run a program from its desktop file.
    "${mod}+Shift+d" = "exec ${i3-dmenu-desktop}";

    # Run autorandr for the current setup.
    "${mod}+Control+Shift+d" = "exec ${profileBin}/autorandr -c";


    # Toggle the split direction for the current container between horizontal
    # and vertical.
    "${mod}+e" = "layout toggle split";

    # Exit the current i3 session.
    "${mod}+Shift+e" =
      let
        # The i3-msg in the current profile.
        i3-msg = "${profileBin}/i3-msg";

        # The i3-nagbar in the current profile.
        i3-nagbar = "${profileBin}/i3-nagbar";

        # The loginctl in the current profile.
        loginctl = "${profileBin}/loginctl";

        # The warning to show.
        warning = builtins.concatStringsSep " " [
          "You pressed the exit shortcut."
          "Do you really want to exit i3?"
          "This will end your X session."
        ];

        # The command to run to exit i3.
        exit = builtins.concatStringsSep " " [
          # Tell i3 to exit.
          "${i3-msg} exit &"

          # Sleep for ten seconds.
          "${profileBin}/sleep 10"

          # Then tell loginctl to terminate the current session, since sometimes
          # when i3 exits not everything gets the message that the session
          # should end.
          "&& ${loginctl} terminate-session \$XDG_SESSION_ID"
        ];

        # The message to exit i3.
        exitMsg = "Yes, exit i3";

        # The full exit command.
        exitCommand =
          "${i3-nagbar} -t warning -m '${warning}' -b '${exitMsg}' '${exit}'";
      in
      "exec \"${exitCommand}\"";


    # Toggle fullscreen for a window.
    "${mod}+f" = "fullscreen toggle";


    # Focus the window left of the current focus.
    "${mod}+h" = "focus left";

    # Move the focused window left.
    "${mod}+Shift+h" = "move left";

    # Start htop in a terminal.
    "${mod}+Control+Shift+h" =
      let
        inherit (config.xsession.windowManager.i3.config) terminal;

        htop = "${profileBin}/htop";
      in
      "exec ${terminal} ${htop}";


    # Run i3-input to input a raw i3 command.
    "${mod}+i" = "exec ${profileBin}/i3-input";


    # Focus the window below the current focus.
    "${mod}+j" = "focus down";

    # Move the focused window down.
    "${mod}+Shift+j" = "move down";


    # Focus the window above the current focus.
    "${mod}+k" = "focus up";

    # Move the focused window up.
    "${mod}+Shift+k" = "move up";


    # Focus the window right of the current focus.
    "${mod}+l" = "focus right";

    # Move the focused window right.
    "${mod}+Shift+l" = "move right";

    # Lock the screen.
    "${mod}+Control+Shift+l" = "exec ${profileBin}/xset s activate";


    # Move to the next workspace.
    "${mod}+n" = "workspace next";

    # Move the currently focused container to the next workspace.
    "${mod}+Shift+n" = "move container to workspace next";

    # Start nautilus to browse files.
    "${mod}+Control+Shift+n" = "exec ${profileBin}/nautilus";


    # Split the current container horizontally.
    "${mod}+o" = "split h";


    # Move to the previous workspace.
    "${mod}+p" = "workspace prev";

    # Move the currently focused container to the previous workspace.
    "${mod}+Shift+p" = "move container to workspace prev";


    # Kill the current window nicely.
    "${mod}+Shift+q" = "kill";

    # Forcibly kill the process owning a window.
    "${mod}+Control+Shift+q" = "exec ${profileBin}/xkill";


    # Switch to resize mode.
    "${mod}+r" = "mode \"resize\"";

    # Rename the current workspace.
    "${mod}+Shift+r" =
      let
        i3-input = "${profileBin}/i3-input";
      in
      "exec ${i3-input} -F 'rename workspace to \"%s\"' -P 'New name: '";

    # Reload i3's configuration.
    "${mod}+Control+r" = "reload";

    # Restart i3.
    "${mod}+Control+Shift+r" = "restart";


    # Take a screenshot.
    "${mod}+Shift+s" =
      "exec ${config.home.sessionVariables.SCREENSHOT_PROGRAM}";


    # Switch to passthrough mode.
    "${mod}+Control+Shift+t" = "mode \"passthrough\"";


    # Suspend the system.
    "${mod}+Control+Shift+u" = "exec ${profileBin}/systemctl suspend";


    # Split the current container vertically.
    "${mod}+v" = "split v";

    # Fetch a previous clipboard entry into the current clipboard.
    "${mod}+Control+v" =
      let
        clipmenu = "${profileBin}/clipmenu";

        clipmenuArgs = builtins.concatStringsSep " " [
          # Match case-insensitively.
          "-i"

          # Show things vertically on 8 lines, since clipboard fetches are
          # probably long.
          "-l 8"
        ];
      in
      "exec ${clipmenu} ${dmenuArgs} ${clipmenuArgs}";


    # Switch to a tabbed layout.
    "${mod}+w" = "layout tabbed";
  } // workspaceBindings;

  # Keybindings for resize mode, where bindings resize tiled or floating
  # windows.
  xsession.windowManager.i3.config.modes."resize" = {
    # Return to the default mode.
    "Return" = "mode \"default\"";
    "Escape" = "mode \"default\"";


    # Shrink the current window's width by 10 pixels if floating, or 5 percent
    # if tiled.
    "h" = "resize shrink width 10 px or 5 ppt";

    # Shrink the current window's width by 1 pixel if floating, or 1 percent
    # if tiled.
    "${mod}+h" = "resize shrink width 1 px or 1 ppt";


    # Grow the current window's height by 10 pixels if floating, or 5 percent if
    # tiled.
    "j" = "resize grow height 10 px or 5 ppt";

    # Grow the current window's height by 1 pixel if floating, or 1 percent if
    # tiled.
    "${mod}+j" = "resize grow height 1 px or 1 ppt";


    # Shrink the current window's height by 10 pixels if floating, or 5 percent
    # if tiled.
    "k" = "resize shrink height 10 px or 5 ppt";

    # Shrink the current window's height by 1 pixel if floating, or 1 percent if
    # tiled.
    "${mod}+k" = "resize shrink height 1 px or 1 ppt";


    # Grow the current window's width by 10 pixels if floating, or 5 percent if
    # tiled.
    "l" = "resize grow width 10 px or 5 ppt";

    # Grow the current window's width by 1 pixel if floating, or 1 percent if
    # tiled.
    "${mod}+l" = "resize grow width 1 px or 1 ppt";
  };

  # Keybindings for passthrough mode, where everything is sent raw to the window
  # except the key binding to exit.
  # This is mainly for games and such that insist on using ALT and need most
  # keybindings here disabled.
  xsession.windowManager.i3.config.modes."passthrough" = {
    # Switch back to default mode.
    "${mod}+Control+Shift+t" = "mode \"default\"";
  };
}
