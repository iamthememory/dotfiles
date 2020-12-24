# Terminal setup for kitty.
{ config
, pkgs
, ...
}:
let
  # Alias SSH to the kitty helper for ensuring the terminfo entry is available
  # on the SSH host.
  shellAliases = {
    ssh = "${config.home.profileDirectory}/bin/kitty +kitten ssh";
  };
in
{
  imports = [
    # Ensure we have basic terminal utilities.
    ../utils

    # Ensure we have the ZSH configuration available.
    ../zsh
  ];

  # Extra packages to add.
  home.packages = with pkgs; [
    # Ensure we have less available, for the scrollback pager.
    less

    # Add ncurses, to ensure we have terminfo databases available.
    ncurses

    # Add the dev output of ncurses too, primarily for the toe binary.
    ncurses.dev
  ];

  # Use kitty as the default terminal, using a single instance for better GPU
  # caching.
  # This is the same variable i3-sensible-terminal uses, so we're using it for
  # our terminal setting.
  # NOTE: I don't know if this is used as-is or not, so it's a wrapper script.
  home.sessionVariables.TERMINAL = pkgs.writeScript "kitty.sh" ''
    #!${pkgs.stdenv.shell}

    exec ${config.home.profileDirectory}/bin/kitty --single-instance "$@"
  '';

  # Enable kitty.
  programs.kitty.enable = true;

  # Extra configuration for kitty.
  programs.kitty.extraConfig = ''
  '';

  # The font to use in kitty, and its package.
  # Here, we use the nerdfonts-patched Li[bt]eration Mono font, with extra
  # glyphs and symbols added.
  programs.kitty.font.name = "LiterationMono Nerd Font Mono";
  programs.kitty.font.package = pkgs.nerdfonts;

  # Keybindings for kitty.
  programs.kitty.keybindings = {
    # Move to the next and previous tabs.
    "kitty_mod+left" = "previous_tab";
    "kitty_mod+right" = "next_tab";

    # Scroll text a single line up or down.
    "kitty_mod+down" = "scroll_line_down";
    "kitty_mod+up" = "scroll_line_up";

    # Scroll text a page up or down.
    "kitty_mod+page_down" = "scroll_page_down";
    "kitty_mod+page_up" = "scroll_page_up";

    # Scroll to the top and bottom.
    "kitty_mod+home" = "scroll_home";
    "kitty_mod+end" = "scroll_end";

    # Create a new window within kitty.
    "kitty_mod+enter" = "new_window";

    # Increase and decrease the font size.
    "kitty_mod+equal" = "change_font_size all +1.0";
    "kitty_mod+minus" = "change_font_size all -1.0";

    # Reset the font size.
    "kitty_mod+backspace" = "change_font_size all 0";

    # Open the kitty command shell.
    "kitty_mod+escape" = "kitty_shell window";

    # Move forward and backward between windows.
    "kitty_mod+]" = "next_window";
    "kitty_mod+[" = "previous_window";

    # Move a window to the top.
    "kitty_mod+`" = "move_window_to_top";

    # Move the current tab backward and forward.
    "kitty_mod+," = "move_tab_backward";
    "kitty_mod+." = "move_tab_forward";

    # Change the current tab title.
    "kitty_mod+;" = "set_tab_title";

    # Move a window backward within a tab.
    "kitty_mod+b" = "move_window_forward";

    # Copy text to the clipboard.
    "kitty_mod+c" = "copy_to_clipboard";

    # Open a URL that's currently visible.
    "kitty_mod+e" = "kitten hints";

    # Move a window forward within a tab.
    "kitty_mod+f" = "move_window_forward";

    # Show the full scrollback buffer in less.
    "kitty_mod+h" = "show_scrollback";

    # Switch to the next window layout.
    "kitty_mod+l" = "next_layout";

    # Create a new OS window for kitty.
    "kitty_mod+n" = "new_os_window";

    # Select a visible filepath/name and insert it at the cursor.
    "kitty_mod+p>f" = "kitten hints --type path --program -";

    # Open selected path with the default open program.
    "kitty_mod+p>shift+f" = "kitten hints --type path";

    # Insert selected hash-like text at the cursor.
    "kitty_mod+p>h" = "kitten hints --type hash --program -";

    # Insert selected line at the cursor.
    "kitty_mod+p>l" = "kitten hints --type line --program -";

    # Insert selected word at the cursor.
    "kitty_mod+p>w" = "kitten hints --type word --program -";

    # Resize the given window.
    "kitty_mod+r" = "start_resizing_window";

    # Paste text from the current selection.
    "kitty_mod+s" = "paste_from_selection";

    # Open a new tab.
    "kitty_mod+t" = "new_tab";

    # Input a unicode character.
    "kitty_mod+u" = "kitten unicode_input";

    # Paste text from the clipboard.
    "kitty_mod+v" = "paste_from_clipboard";

    # Switch to the given window number.
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
  };

  # Settings for kitty.
  programs.kitty.settings =
    let
      # Color scheme settings.
      colorSettings =
        let
          # The solarized-dark palette, as mapped onto the basic 16 terminal
          # colors.
          colors = {
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
        rec {
          # The border color for active, inactive, and bell-ed windows.
          active_border_color = colors.green;
          bell_border_color = colors.brred;
          inactive_border_color = colors.yellow;

          # The background color.
          background = colors.brblack;

          # Black and bright black.
          color0 = colors.black;
          color8 = colors.brblack;

          # Black and bright red.
          color1 = colors.red;
          color9 = colors.brred;

          # Black and bright green.
          color2 = colors.green;
          color10 = colors.brgreen;

          # Black and bright yellow.
          color3 = colors.yellow;
          color11 = colors.bryellow;

          # Black and bright blue.
          color4 = colors.blue;
          color12 = colors.brblue;

          # Black and bright magenta.
          color5 = colors.magenta;
          color13 = colors.brmagenta;

          # Black and bright cyan.
          color6 = colors.cyan;
          color14 = colors.brcyan;

          # Black and bright white.
          color7 = colors.white;
          color15 = colors.brwhite;

          # The cursor color.
          cursor = colors.brcyan;

          # The text under the cursor should be the background color the cell
          # would have if the cursor weren't there.
          cursor_text_color = "background";

          # The foreground color.
          foreground = colors.brblue;

          # When selecting text, reverse the foreground and background from the
          # default.
          selection_background = foreground;
          selection_foreground = background;

          # The color to use for URLs on mouseover.
          url_color = colors.blue;
        };
    in
    {
      # Allow other programs to control kitty.
      allow_remote_control = true;

      # Clear all default shortcuts.
      # NOTE: This works because home-manager puts the settings before
      # keybindings.
      clear_all_shortcuts = true;

      # Don't blink the cursor.
      cursor_blink_interval = 0;

      # Draw all borders for inactive windows.
      draw_minimal_borders = false;

      # Use the default editor if available, or fall back to defaults.
      editor = config.home.sessionVariables.EDITOR or ".";

      # Disable the audio bell, to only use visual indicators.
      enable_audio_bell = false;

      # Use size 9.0 font.
      font_size = "9.0";

      # Use ctrl+shift as the kitty modifier.
      kitty_mod = "ctrl+shift";

      # Listen on the given UNIX socket.
      listen_on = "unix:@/tmp/kitty-${config.home.username}";

      # Don't hide the mouse cursor.
      mouse_hide_wait = "0";

      # Open URLs with the browser if available.
      open_url_with = config.home.sessionVariables.BROWSER or "default";

      # Keep 10_000 lines of interactive scrollback.
      scrollback_lines = 10000;

      # The command to view the full scrollback buffer.
      scrollback_pager =
        let
          less = "${config.home.profileDirectory}/bin/less";
        in
        "${less} --chop-long-lines --RAW-CONTROL-CHARS +INPUT_LINE_NUMBER";

      # The size in megabytes for the full scrollback buffer that can be viewed
      # in a pager.
      # This is about 2500-10_000 lines per megabyte.
      scrollback_pager_history_size = 32;

      # Consider all of these characters as part of words when double-clicking
      # to select text.
      select_by_word_characters = ":@-./_~?&=%+#";

      # Use ZSH as the shell.
      shell = "${config.home.profileDirectory}/bin/zsh";

      # Use a powerline-style tab bar separator.
      tab_bar_style = "powerline";

      # The tab title format.
      tab_title_template = "{index}: {title}";

      # Scroll one line at a time when scrolling with a touchpad.
      touch_scroll_multiplier = "1.0";

      # Style URLs with a single underline on mouse-over.
      url_style = "single";

      # Flash the screen for 0.2 seconds for the visual bell.
      visual_bell_duration = "0.2";

      # Scroll one line at a time when scrolling with a mousewheel.
      wheel_scroll_multiplier = "1.0";

      # Draw window borders as 1.0pt wide.
      window_border_width = "1.0pt";

      # Resize windows by one cell at a time.
      window_resize_step_cells = 1;
      window_resize_step_lines = 1;
    } // colorSettings;

  # Add shell aliases for all shells.
  # NOTE: These will have no effect unless the relevant shell is enabled.
  programs.bash.shellAliases = shellAliases;
  programs.fish.shellAliases = shellAliases;
  programs.zsh.shellAliases = shellAliases;

  # Add kitty completion for Bash.
  programs.bash.initExtra = ''
    # Add completion for kitty.
    source <(${config.home.profileDirectory}/bin/kitty + complete setup bash)
  '';

  # Add kitty completion for ZSH.
  programs.zsh.initExtra = ''
    # Add kitty zsh completion.
    ${config.home.profileDirectory}/bin/kitty + complete setup zsh | source /dev/stdin
  '';
}
