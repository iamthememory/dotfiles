# Dunst configuration.
{ config
, inputs
, lib
, pkgs
, ...
}: {
  imports = [
    # Ensure our fonts are available.
    ./fonts.nix
  ];

  home.packages = with pkgs; [
    # Ensure dmenu is available.
    dmenu

    # Ensure Adwaita icons are available.
    gnome.adwaita-icon-theme
  ];

  # Enable dunst for notifications.
  services.dunst.enable = true;

  # Dunst settings.
  services.dunst.settings = with inputs.lib.solarized.colorNames; {
    # Global settings.
    global =
      let
        # Optional settings for the browser that must only be set if the browser
        # is set.
        browserSettings =
          let
            # Set the browser command if available.
            browserCommand = config.home.sessionVariables.BROWSER or null;
          in
          if browserCommand == null then { }
          else {
            browser = browserCommand;
          };
      in
      {
        # Align text to the left.
        alignment = "left";

        # Always run scripts, even for suppressed notifications.
        always_run_script = true;

        # Don't round notification window corners.
        corner_radius = 0;

        # How to invoke dmenu.
        dmenu =
          let
            # The path to dmenu.
            dmenu = "${config.home.profileDirectory}/bin/dmenu";

            # The arguments to dmenu.
            dmenuArgs = builtins.concatStringsSep " " [
              # Use the same font we use for dunst, just with font size
              # specified how Fontconfig prefers it.
              "-fn 'LiterationMono Nerd Font Mono:size=9:antialias=true:autohint=true'"

              # The background color to use.
              "-nb '${base03}'"

              # The normal text color.
              "-nf '${base00}'"

              # The background for the current selection.
              "-sb '${base00}'"

              # The text color for the current selection.
              "-sf '${base03}'"

              # The prompt to show.
              "-p 'Dunst: '"
            ];
          in
          "${dmenu} ${dmenuArgs}";

        # Put an ellipsis in the middle of the text when it can't fit.
        # NOTE: This doesn't apply when doing word wrapping and is just here for
        # completeness.
        ellipsize = "middle";

        # Show notifications on the monitor with the mouse on it.
        follow = "mouse";

        # The font to use.
        font = "LiterationMono Nerd Font Mono 9";

        # Don't force Xinerama for multi-monitor support.
        # Use RandR instead.
        force_xinerama = false;

        # The format of the message, with markup.
        format = "<i>%a</i>: <b>%s</b>\\n%b\\n%p";

        # The color of the frame.
        frame_color = base1;

        # Draw a 3-pixel-wide frame around the notification window.
        frame_width = 3;

        # The notification window geometry, as [{width}]x{height}[+/-{x}+/-{y}].
        # Put the notifications 300 pixels wide, at the upper right corner of
        # the screen, offset a bit.
        geometry = "300x5-30+20";

        # Show the number of stacked duplicate notifications.
        hide_duplicate_count = false;

        # Keep 50 notifications in history.
        history_length = 50;

        # Pad the space to the sides of the notification text.
        horizontal_padding = 8;

        # The icon path, overridden here to avoid using system icons.
        icon_path =
          let
            # The icon size to use.
            iconSize = "scalable";

            # The categories for the Adwaita icons.
            adwaitaCategories = [
              "actions"
              "apps"
              "categories"
              "devices"
              "emblems"
              "emotes"
              "legacy"
              "mimetypes"
              "places"
              "status"
              "ui"
            ];

            # The path to each Adwaita icon category in the profile.
            adwaitaIcons =
              let
                # The base path to all icons.
                basePath = "${config.home.profileDirectory}/share/icons";

                # The path to all icons of our chosen size.
                sizePath = "${basePath}/Adwaita/${iconSize}";
              in
              map (cat: "${sizePath}/${cat}") adwaitaCategories;

            # The path to the default icons.
            iconPath = builtins.concatStringsSep ":" adwaitaIcons;
          in
          lib.mkForce iconPath;

        # Show icons on the left side of the window.
        icon_position = "left";

        # Allow applications that sent notifications to close them before the
        # default timeout.
        ignore_dbusclose = false;

        # Don't ignore newlines in notification text.
        ignore_newline = false;

        # Show how many notifications are hidden because they don't fit.
        indicate_hidden = true;

        # If there's no mouse or keyboard input for over two minutes, don't
        # remove messages.
        idle_threshold = 120;

        # Don't put spacing between lines of text.
        line_height = 0;

        # Use full Pango markup in notifications, for HTML-like markup for
        # formatting.
        markup = "full";

        # Scale icons to 32x32.
        min_icon_size = 32;
        max_icon_size = 32;

        # On left-click, close the current notification.
        mouse_left_click = "close_current";

        # On middle-click, do whatever action the notification has, or open a
        # menu to select one.
        mouse_middle_click = "do_action";

        # On right-click, close all notifications.
        mouse_right_click = "close_all";

        # Set the notification height to 0, allowing dunst to shrink window
        # height to only what's needed.
        notification_height = 0;

        # Pad the space between the notification text and separators.
        padding = 8;

        # Enable the progress bar feature for percentages.
        # This seems to only be in dunst's master for the moment, but is here
        # for when it gets into a release.
        progress_bar = true;

        # The progress bar height, including frame.
        progress_bar_height = 10;

        # The width of the progress bar frame.
        progress_bar_frame_width = 1;

        # The minimum and maximum width of the progress bar.
        progress_bar_min_width = 250;
        progress_bar_max_width = 250;

        # Use the same color for the separator as the frame color.
        separator_color = "frame";

        # Separate notifications with a two-pixel-wide line.
        separator_height = 2;

        # Show message age if older than a minute.
        show_age_threshold = 60;

        # Show indicators for URLs and actions.
        show_indicators = true;

        # Don't shrink the window if smaller than the maximum width.
        shrink = false;

        # Sort messages by urgency.
        sort = true;

        # Stack duplicate notifications together.
        stack_duplicates = true;

        # Show a mesage on dunst startup just to know it's been properly
        # (re)started by dbus.
        startup_notification = "true";

        # When manually showing message history, don't time them out and hide
        # them before being manually dismissed again.
        sticky_history = true;

        # The title and class to use for dunst windows.
        title = "Dunst";
        class = "Dunst";

        # Make the notification window slightly transparent.
        transparency = 20;

        # Show important messages from dunst in logs.
        verbosity = "mesg";

        # Center text and icons vertically.
        vertical_alignment = "center";

        # Wrap notification lines if they don't fit.
        word_wrap = true;
      } // browserSettings;

    # Experimental features.
    experimental = {
      # Don't calculate DPI separately for each monitor.
      per_monitor_dpi = false;
    };

    # Low-urgency message settings.
    urgency_low = {
      # The background color.
      background = base03;

      # The foreground color.
      foreground = base01;

      # Timeout after 10 seconds.
      timeout = 10;
    };

    # Normal-urgency message settings.
    urgency_normal = {
      # The background color.
      background = base02;

      # The foreground color.
      foreground = base1;

      # Timeout after 10 seconds.
      timeout = 10;
    };

    # Critical-urgency message settings.
    urgency_critical = {
      # The background color.
      background = red;

      # The foreground color.
      foreground = base2;

      # Don't timeout critical messages.
      timeout = 0;
    };
  };
}
