# Theme and color settings for i3.
{ config
, inputs
, ...
}:
let
  inherit (inputs.lib.solarized) colorNames;

  # The font settings to to use below.
  fonts = {
    # The names of the fonts to use, in order.
    names = [
      "LiterationMono Nerd Font Mono"
    ];

    # The size of font to use.
    size = 9.0;
  };
in
{
  imports = [
    # Ensure fonts are available.
    ../fonts.nix

    # Ensure the i3status-rust config is available.
    ./bars.nix
  ];

  # The upper and lower bar configurations.
  xsession.windowManager.i3.config.bars =
    let
      # The color settings for each bar.
      colors = {
        # The colors for the workspace button for an active workspace.
        activeWorkspace = {
          background = colorNames.base0;
          border = colorNames.base03;
          text = colorNames.base02;
        };

        # The background color of the bar.
        background = colorNames.base03;

        # The colors for binding mode indicators.
        bindingMode = {
          background = colorNames.red;
          border = colorNames.base03;
          text = colorNames.base2;
        };

        # The colors for focused workspaces.
        focusedWorkspace = {
          background = colorNames.violet;
          border = colorNames.base03;
          text = colorNames.base2;
        };

        # The colors for inactive workspaces.
        inactiveWorkspace = {
          background = colorNames.base02;
          border = colorNames.base03;
          text = colorNames.base0;
        };

        # The color for status line separators.
        separator = colorNames.base1;

        # The foreground color for text for the statusline.
        statusline = colorNames.base0;

        # The colors to use for urgent workspaces.
        urgentWorkspace = {
          background = colorNames.red;
          border = colorNames.base03;
          text = colorNames.base2;
        };
      };

      # Given a bar ID, return the status command to run.
      statusCommand = bar:
        let
          inherit (config.home) profileDirectory;
          inherit (config.xdg) configHome;

          i3status-rust = "${profileDirectory}/bin/i3status-rs";

          configFile = "${configHome}/i3status-rust/config-${bar}.toml";
        in
        "${i3status-rust} ${configFile}";
    in
    [
      # The top bar configuration.
      {
        inherit colors fonts;

        # The ID for this bar.
        id = "bar-top";

        # The position for this bar.
        position = "top";

        # Run i3status-rust for this bar.
        statusCommand = statusCommand "top";

        # Don't show the tray on the top bar.
        trayOutput = "none";

        # Don't show workspace buttons on the top bar.
        workspaceButtons = false;
      }

      # The bottom bar configuration.
      {
        inherit colors fonts;

        # The ID for this bar.
        id = "bar-bottom";

        # The position for this bar.
        position = "bottom";

        # Run i3status-rust for this bar.
        statusCommand = statusCommand "bottom";

        # Show the tray on the primary monitor.
        trayOutput = "primary";

        # Show workspace buttons.
        workspaceButtons = true;

        # Show workspace numbers.
        workspaceNumbers = true;
      }
    ];

  # Color settings for i3.
  xsession.windowManager.i3.config.colors = rec {
    # The overall background color.
    background = colorNames.base03;

    # Colors for the currently focused window.
    focused = rec {
      border = background;
      background = colorNames.violet;
      text = colorNames.base2;
      indicator = colorNames.magenta;
      childBorder = background;
    };

    # Colors for an inactive window within the currently focused container.
    focusedInactive = rec {
      border = background;
      background = colorNames.base0;
      text = colorNames.base02;
      indicator = colorNames.cyan;
      childBorder = background;
    };

    # Colors for placeholder windows when restoring layouts.
    placeholder = unfocused;

    # Colors for unfocused windows.
    unfocused = rec {
      border = background;
      background = colorNames.base02;
      text = colorNames.base00;
      indicator = colorNames.cyan;
      childBorder = background;
    };

    # Colors for urgent windows with activity.
    urgent = rec {
      border = background;
      background = colorNames.red;
      text = colorNames.base2;
      indicator = colorNames.magenta;
      childBorder = background;
    };
  };

  # The fonts to use for window titles.
  xsession.windowManager.i3.config.fonts = fonts;
}
