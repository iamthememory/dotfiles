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
  home.packages = with pkgs; [
    # Add the unclutter package to the profile.
    config.services.unclutter.package

    # Make sure sed and grep are available.
    gnugrep
    gnused

    # Ensure xinput is available.
    xinput
  ];

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

  # Use a size 16 Adwaita cursor.
  home.pointerCursor.package = pkgs.adwaita-icon-theme;
  home.pointerCursor.name = "Adwaita";
  home.pointerCursor.size = 16;
  home.pointerCursor.gtk.enable = true;
  home.pointerCursor.x11.enable = true;

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
    '';

  # Turn on Num Lock when starting the X11 session.
  xsession.numlock.enable = true;
}
