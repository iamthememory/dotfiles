# Various input options for X11.
{ config
, lib
, pkgs
, ...
}: {
  imports = [
    # Ensure fonts are available.
    ./fonts.nix
  ];

  # Extra packages to install.
  home.packages =
    let
      # An ibus package with a number of plugins for a variety of input methods.
      ibus-full = pkgs.ibus-with-plugins.override {
        plugins = with pkgs.ibus-engines; [
          # An input method for Japanese using romaji.
          anthy

          # Table-based inputs, such as LaTeX.
          table
          table-others

          # A context-sensitive input to speed up typing.
          (typing-booster.override
            {
              # Languages in pkgs.hunspellDicts.
              langs = [
                # English dictionaries.
                "en_GB-large"
                "en_US"
                "en_US-large"

                # The German dictionary.
                "de_DE"
              ];
            })

          # Input unicode emoji by their names.
          uniemoji
        ];
      };
    in
    with pkgs; [
      # Add the unclutter package to the profile.
      config.services.unclutter.package

      # Make sure sed and grep are available.
      gnugrep
      gnused

      # Install ibus with our plugins..
      ibus-full

      # Ensure xinput is available.
      xorg.xinput
    ];

  # Ibus dconf settings.
  dconf.settings = {
    # German settings for the ibus typing booster.
    "desktop/ibus/engine/typing-booster/typing-booster-de-de" = {
      # Don't use a special input method under typing-booster.
      inputmethod = "NoIme";
    };

    # English settings for the ibus typing booster.
    "desktop/ibus/engine/typing-booster/typing-booster-en-us" = {
      # Don't use a special input method under typing-booster.
      inputmethod = "NoIme";
    };

    # General ibus settings.
    "desktop/ibus/general" = rec {
      # The order to use ibus engines in.
      engines-order = [
        # English, via the raw keyboard input.
        "xkb:us::eng"

        # The typing booster.
        "typing-booster"

        # LaTeX-like symbol input.
        "table:latex"

        # Emoji, by their unicode names.
        "uniemoji"

        # Anthy, for Japanese input.
        "anthy"
      ];

      # Preload all of the engines we use above.
      preload-engines = engines-order;

      # Use the system's keyboard layout.
      use-system-keyboard-layout = true;
    };

    # The key to trigger ibus or switch engines.
    "desktop/ibus/general/hotkey".triggers = [
      "<Control><Shift>space"
    ];

    # Panel settings for ibus.
    "desktop/ibus/panel" = {
      # Use Literation Mono for showing matches.
      custom-font = "LiterationMono Nerd Font Mono 10";
      use-custom-font = true;

      # Show the system tray icon.
      show = 1;
    };

    # Emoji settings for ibus.
    "desktop/ibus/panel/emoji" = {
      # Use the Noto emoji font for showing emoji matches, since it has
      # good support for a variety of emoji.
      font = "Noto Color Emoji 16";

      # Allow partial emoji description matches, rather than prefix-only
      # matching.
      has-partial-match = true;

      # Match emoji by description once at least three characters are
      # typed.
      partial-match-condition = 2;
    };

    # Typing-booster settings for ibus.
    "org/freedesktop/ibus/engine/typing-booster" = {
      # Predict emoji.
      emojipredictions = true;

      # Don't use an underlying input method.
      inputmethod = "NoIME";
    };
  };

  # Use a US keyboard layout.
  home.keyboard.layout = "us";

  # Use the pc104 keyboard model by default, which is roughly the standard, full
  # US PC keyboard model, and usually a good default.
  home.keyboard.model = lib.mkDefault "pc104";

  # The keyboard options.
  home.keyboard.options = [
    # Make Caps Lock act like Esc, but Shift+Caps Lock is regular Caps Lock.
    "caps:escape_shifted_capslock"

    # Make the left Windows key the compose key.
    "compose:lwin"

    # Make the numpad always enter digits.
    "numpad:mac"
  ];

  # Use the default keyboard layout variant by default.
  # This can be overridden for, e.g., dvorak.
  home.keyboard.variant = lib.mkDefault "";

  # Use ibus for input for programs in X11.
  home.sessionVariables.GTK_IM_MODULE = "ibus";
  home.sessionVariables.QT_IM_MODULE = "ibus";
  home.sessionVariables.QT3_IM_MODULE = "ibus";
  home.sessionVariables.QT4_IM_MODULE = "ibus";
  home.sessionVariables.QT5_IM_MODULE = "ibus";
  home.sessionVariables.XMODIFIERS = "@im=ibus";

  # Add clipmenu to keep track of old clipboard entries.
  services.clipmenu.enable = true;

  # Enable the unclutter daemon to hide the mouse pointer on inactivity.
  services.unclutter.enable = true;

  # Extra commands to run when starting X11.
  xsession.initExtra =
    let
      # The location of the profile bin directory.
      bin = "${config.home.profileDirectory}/bin";

      # The location of various tools in our profile directory.
      grep = "${bin}/grep";
      sed = "${bin}/sed";
      xinput = "${bin}/xinput";

      # The location of ibus.
      ibus-daemon = "${bin}/ibus-daemon";
    in
    ''
      # Set middle-button emulation for any (Logitech) mice.
      # This allows clicking both the right and left mouse button at the same time
      # to count as a middle click, rather than awkwardly trying to click the
      # scrollwheel without spinning it at all.
      # FIXME: This should probably be extended to handle any non-touchpad mice.
      for input in $("${xinput}" --list | "${grep}" Logitech | "${sed}" -r 's/.*\tid=([0-9]+)[^0-9].*$/\1/')
      do
        # Set middle-button emulation for this input.
        # FIXME: This should probably not assume libinput.
        "${xinput}" --set-prop "$input" "libinput Middle Emulation Enabled" 1
      done

      # Start the ibus daemon.
      "${ibus-daemon}" --daemonize --replace --restart
    '';

  # Turn on Num Lock when starting the X11 session.
  xsession.numlock.enable = true;

  # Use a size 16 Adwaita cursor.
  xsession.pointerCursor.package = pkgs.gnome3.adwaita-icon-theme;
  xsession.pointerCursor.name = "Adwaita";
  xsession.pointerCursor.size = 16;
}
