# Keyring and password settings for GUI settings.
{ config
, pkgs
, ...
}:
let
  # The location of the seahorse askpass in the profile..
  askpass = "${config.home.profileDirectory}/libexec/seahorse/ssh-askpass";

  # The i3 modifier key.
  mod = config.xsession.windowManager.i3.config.modifier;

  # The current xinput location.
  xinput = "${config.home.profileDirectory}/bin/xinput";

  # The Yubikey input name.
  yubikeyInput = "Yubico Yubikey 4 OTP+U2F+CCID";
in
{
  home.packages = with pkgs; [
    # Ensure seahorse is available for both a GUI askpass, and managing
    # gnome-keyring.
    gnome3.seahorse

    # Add the keybase filesystem package explicitly to ensure git-remote-keybase
    # is available.
    kbfs

    # Add the keybase GUI.
    keybase-gui

    # Ensure xinput is available.
    xorg.xinput

    # The Yubikey manager and its GUI.
    yubikey-manager
    yubikey-manager-qt

    # The Yubikey personalization tool and its GUI.
    yubikey-personalization
    yubikey-personalization-gui

    # The Yubikey oath configuration program.
    yubioath-desktop
  ];

  # The askpass to use for GUI ssh and sudo prompts.
  home.sessionVariables.SSH_ASKPASS = askpass;
  home.sessionVariables.SUDO_ASKPASS = askpass;

  # Enable keybase's FUSE mount.
  services.kbfs.enable = true;

  # Enable the keybase service.
  services.keybase.enable = true;

  # Extra commands to run when starting X11.
  xsession.initExtra = ''
    # Disable Yubikey input by default.
    # This doesn't prevent smarter programs from asking the Yubikey for a
    # token, then touching it to authorize, it only prevents the Yubikey from
    # emulating a keyboard to type a one time code every time it's bumped.
    # FIXME: This should probably cover more models or be host-specific.
    "${xinput}" disable '${yubikeyInput}'
  '';

  # i3 keybindings for the Yubikey.
  xsession.windowManager.i3.config.keybindings = {
    # Disable yubikey input.
    "${mod}+Shift+y" = "exec ${xinput} disable '${yubikeyInput}'";

    # Enable yubikey input.
    "${mod}+Control+Shift+y" = "exec ${xinput} enable '${yubikeyInput}'";
  };

  # Extra i3 configuration.
  xsession.windowManager.i3.extraConfig = ''
    # Put keybase's GUI on the scratchpad.
    for_window [class="^Keybase$"] move scratchpad
  '';

  # Make keybase's GUI a floating window.
  xsession.windowManager.i3.config.floating.criteria = [
    { class = "^Keybase$"; }
  ];

  # Start keybase's GUI on i3 startup.
  xsession.windowManager.i3.config.startup = [
    { command = "${config.home.profileDirectory}/bin/keybase-gui"; }
  ];
}
