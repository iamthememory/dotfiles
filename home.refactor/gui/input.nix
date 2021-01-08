# Various input options for X11.
{ config
, lib
, pkgs
, ...
}: {

  # Extra packages to install.
  home.packages = with pkgs; [
    # Make sure sed and grep are available.
    gnugrep
    gnused

    # Install ibus with our plugins..
    ibus-full

    # Ensure xinput is available.
    xorg.xinput
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

      # Disable Yubikey input by default.
      # This doesn't prevent smarter programs from asking the Yubikey for a
      # token, then touching it to authorize, it only prevents the Yubikey from
      # emulating a keyboard to type a one time code every time it's bumped.
      # FIXME: This should probably cover more models or be host-specific.
      "${xinput}" disable 'Yubico Yubikey 4 OTP+U2F+CCID'
    '';

  # Turn on Num Lock when starting the X11 session.
  xsession.numlock.enable = true;

  # Use a size 16 Adwaita cursor.
  xsession.pointerCursor.package = pkgs.gnome3.adwaita-icon-theme;
  xsession.pointerCursor.name = "Adwaita";
  xsession.pointerCursor.size = 16;
}
