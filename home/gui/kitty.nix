{ config, lib, options, ... }:
let
  inherit (import ../channels.nix) unstable;
  pkgs = unstable;

  mkKittyConfig = {
    opts ? {},
    mod ? "ctrl+shift",
    keys ? {},
    clearKeys ? "yes",
    extra ? ""
  }:
    (pkgs.lib.generators.toKeyValue {
      mkKeyValue = k: v: "${k} ${toString v}";
    } opts) + ''
      clear_all_shortcuts ${clearKeys}
      kitty_mod ${mod}
    '' + (pkgs.lib.generators.toKeyValue {
      mkKeyValue = k: v: "map ${k} ${toString v}";
    } keys) + extra;

  colors = {
    # Solarized dark.

    black = "#073642";
    brblack = "#002b36";

    red = "#dc322f";
    brred = "#cb4b16";

    green = "#859900";
    brgreen = "#586e75";

    yellow = "#b58900";
    bryellow = "#657b83";

    blue = "#268bd2";
    brblue = "#839496";

    magenta = "#d33682";
    brmagenta = "#6c71c4";

    cyan = "#2aa198";
    brcyan = "#93a1a1";

    white = "#eee8d5";
    brwhite = "#fdf6e3";
  };
in
  {
    home.packages = with pkgs; [
      kitty
      ncurses
      ncurses.dev
    ];

    xdg.configFile."kitty/kitty.conf" = {
      text = mkKittyConfig {
        mod = "ctrl+shift";


        keys = {
          # Clipboard.

          "kitty_mod+c" = "copy_to_clipboard";
          "kitty_mod+v" = "paste_from_clipboard";
          "kitty_mod+s" = "paste_from_selection";
          "kitty_mod+o" = "pass_selection_to_program";


          # Scrolling.

          "kitty_mod+k" = "scroll_line_up";
          "kitty_mod+j" = "scroll_line_down";

          "kitty_mod+page_up" = "scroll_page_up";
          "kitty_mod+page_down" = "scroll_page_down";

          "kitty_mod+home" = "scroll_home";
          "kitty_mod+end" = "scroll_end";

          # Show scrollback buffer in less.
          "kitty_mod+h" = "show_scrollback";


          # Windows.

          "kitty_mod+enter" = "new_window";
          "kitty_mod+n" = "new_os_window";

          "kitty_mod+w" = "close_window";

          "kitty_mod+]" = "next_window";
          "kitty_mod+[" = "previous_window";

          "kitty_mod+f" = "move_window_forward";
          "kitty_mod+b" = "move_window_backward";
          "kitty_mod+`" = "move_window_to_top";

          "kitty_mod+r" = "start_resizing_window";

          "kitty_mod+1" = "first_window";
          "kitty_mod+2" = "second_window";
          "kitty_mod+3" = "third_window";
          "kitty_mod+4" = "fourth_window";
          "kitty_mod+5" = "fifth_window";
          "kitty_mod+6" = "sixth_window";
          "kitty_mod+7" = "seventh_window";
          "kitty_mod+8" = "eighth_window";
          "kitty_mod+9" = "ninth_window";
          "kitty_mod+0" = "tenth_window";


          # Tabs.

          "kitty_mod+right" = "next_tab";
          "kitty_mod+left" = "previous_tab";

          "kitty_mod+t" = "new_tab";
          "kitty_mod+q" = "close_tab";

          "kitty_mod+." = "move_tab_forward";
          "kitty_mod+," = "move_tab_backward";

          "kitty_mod+;" = "set_tab_title";


          # Layout.

          "kitty_mod+l" = "next_layout";


          # Fonts.

          "kitty_mod+equal" = "change_font_size all +1.0";
          "kitty_mod+minus" = "change_font_size all -1.0";

          # Reset font size.
          "kitty_mod+backspace" = "change_font_size all 0";


          # Select/act on visible text.

          # Open visible URL.
          "kitty_mod+e" = "kitten hints";

          # Insert selected path.
          "kitty_mod+p>f" = "kitten hints --type path --program -";

          # Open selected path.
          "kitty_mod+p>shift+f" = "kitten hints --type path";

          # Insert selected line.
          "kitty_mod+p>l" = "kitten hints --type line --program -";

          # Insert selected word.
          "kitty_mod+p>w" = "kitten hints --type word --program -";

          # Insert selected hash.
          "kitty_mod+p>h" = "kitten hints --type hash --program -";


          # Miscellaneous.

          # Unicode input.
          "kitty_mod+u" = "kitten unicode_input";

          # Open the kitty command shell.
          "kitty_mod+escape" = "kitty_shell window";

          # Reset the terminal.
          "kitty_mod+delete" = "clear_terminal reset active";
        };


        opts = {
          # Fonts.

          font_family = "Literation Mono Nerd Font";
          bold_font = "Literation Mono Nerd Font";
          italic_font = "Literation Mono Nerd Font";
          bold_italic_font = "Literation Mono Nerd Font";

          font_size = "9.0";

          # Adjust the size of each character cell.
          adjust_line_height = 0;
          adjust_column_width = 0;

          # The lines for box drawing unicode characters.
          box_drawing_scale = "0.001, 1, 1.5, 2";


          # Cursor.

          cursor = colors.brcyan;
          cursor_text_color = "background";

          cursor_shape = "block";

          cursor_blink_interval = "0.0";
          cursor_stop_blinking_after = "0.0";


          # Scrollback.

          scrollback_lines = 10000;

          scrollback_pager = "${pkgs.less}/bin/less --chop-long-lines --RAW-CONTROL-CHARS +INPUT_LINE_NUMBER";

          # The scrollback history for viewing in a pager.
          # This is in megabytes, about 2500 lines per megabyte.
          scrollback_pager_history_size = 16;

          # Mouse wheel scrolling multiplier.
          wheel_scroll_multiplier = "1.0";

          # Touchpad scrolling multiplier.
          touch_scroll_multiplier = "1.0";


          # Mouse.

          url_color = colors.blue;

          # The URL style can be none/single/double/curly
          url_style = "single";

          open_url_modifiers = "kitty_mod";

          open_url_with = "${config.programs.chromium.package}/bin/chromium-browser";

          copy_on_select = "no";

          rectangle_select_modifiers = "ctrl+alt";

          # The non-alphanumeric characters also part of a word.
          select_by_word_characters = ":@-./_~?&=%+#";

          # Use the default double/triple click interval.
          click_interval = "-1.0";

          mouse_hide_wait = "0.0";

          focus_follows_mouse = "no";


          # Performance.

          # Milliseconds between screen updates.
          repaint_delay = 10;

          input_delay = 3;

          sync_to_monitor = "yes";


          # Bell.

          enable_audio_bell = "no";

          visual_bell_duration = "0.1";

          window_alert_on_bell = "yes";

          bell_on_tab = "yes";


          # Window layout.

          remember_window_size = "yes";

          initial_window_width = 640;
          initial_window_height = 400;

          enabled_layouts = "*";

          window_resize_step_cells = 1;
          window_resize_step_lines = 1;

          window_border_width = "1.0";

          draw_minimal_borders = "yes";

          window_margin_width = "0.0";

          single_window_margin_width = "-1000.0";

          window_padding_width = "0.0";

          active_border_color = colors.green;
          inactive_border_color = colors.yellow;
          bell_border_color = colors.brred;

          inactive_text_alpha = "1.0";

          hide_window_decorations = "no";


          # Tab bar.

          tab_bar_edge = "bottom";

          tab_bar_margin_width = "0.0";

          tab_bar_style = "separator";

          tab_fade = "0.25 0.5 0.75 1";

          tab_separator = "┇";

          tab_title_template = "{index}: {title}";

          active_tab_foreground = "#000";
          active_tab_background = "#eee";
          active_tab_font_style = "bold-italic";

          inactive_tab_foreground = "#444";
          inactive_tab_background = "#999";
          inactive_tab_font_style = "normal";


          # Color scheme.

          foreground = colors.brblue;
          background = colors.brblack;

          background_opacity = "1.0";
          dynamic_background_opacity = "no";

          dim_opacity = "0.75";

          selection_foreground = colors.brblack;
          selection_background = colors.brblue;

          color0 = colors.black;
          color8 = colors.brblack;

          color1 = colors.red;
          color9 = colors.brred;

          color2 = colors.green;
          color10 = colors.brgreen;

          color3 = colors.yellow;
          color11 = colors.bryellow;

          color4 = colors.blue;
          color12 = colors.brblue;

          color5 = colors.magenta;
          color13 = colors.brmagenta;

          color6 = colors.cyan;
          color14 = colors.brcyan;

          color7 = colors.white;
          color15 = colors.brwhite;


          # Advanced.

          shell = ".";

          editor = ".";

          close_on_child_death = "no";

          allow_remote_control = "yes";

          startup_session = "none";

          clipboard_control = "write-clipboard write-primary";

          term = "xterm-kitty";


          # MacOS tweaks.

          macos_titlebar_color = "system";

          macos_option_as_alt = "yes";

          macos_hide_from_tasks = "no";

          macos_quit_when_last_window_closed = "no";

          macos_window_resizable = "yes";

          macos_thicken_font = 0;

          macos_traditional_fullscreen = "no";

          macos_custom_beam_cursor = "no";
        };


        extra = ''
          #symbol_map UnicodeCodepoints FontFamilyName
          #env VAR=x
        '';
      };
    };
  }
