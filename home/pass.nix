# Configure pass.
{ config
, inputs
, pkgs
, ...
}:
let
  browserpassChromeID = "naepdomgkenhinolocfifgehidddafch";
in
{
  # Add additional passphrase-related packages.
  home.packages = with pkgs; [
    # A package for generating diceware passwords.
    diceware
  ];

  # Enable the host-side program for the browserpass extension, which allows
  # using passwords stored in pass in the browser.
  programs.browserpass.enable = true;

  # Enable the host-side program for browsers which are enabled.
  programs.browserpass.browsers =
    let
      inherit (config) programs;

      chromeEnabled = programs.google-chrome.enable
        || programs.google-chrome-beta.enable
        || programs.google-chrome-dev.enable;

      # NOTE: I'm not including vivaldi because there's no option in home-manager
      # to enable vivaldi.
      chrome = if chromeEnabled then [ "chrome" ] else [ ];
      chromium = if programs.chromium.enable then [ "chromium" ] else [ ];
      firefox = if programs.firefox.enable then [ "firefox" ] else [ ];
    in
    chrome ++ chromium ++ firefox;

  # Enable the browserpass extension for any browsers that're enabled.
  # NOTE: These will only do anything if the applicable browser is also
  # enabled.
  programs.chromium.extensions = [ browserpassChromeID ];
  programs.google-chrome.extensions = [ browserpassChromeID ];
  programs.google-chrome-beta.extensions = [ browserpassChromeID ];
  programs.google-chrome-dev.extensions = [ browserpassChromeID ];
  programs.firefox.extensions =
    let
      inherit (inputs.nur.nur.repos.rycee) firefox-addons;
    in
    [ firefox-addons.browserpass ];

  # Enable pass.
  programs.password-store.enable = true;

  # Specify the extensions to include with pass.
  programs.password-store.package = pkgs.pass.withExtensions (exts: with exts; [
    # A check to audit if any passwords have been in breaches on
    # haveibeenpwned.com without revealing the password or its hash.
    pass-audit

    # A tool to generate diceware-like passphrases.
    pass-genphrase

    # A tool to manage one-time passwords and generate them from a shared
    # secret.
    pass-otp

    # A tool to easily update a number of passwords.
    pass-update
  ]);

  # Settings for pass.
  # NOTE: These go into the session variables.
  programs.password-store.settings = {
    # Keep passwords in the clipboard for 45 seconds before clearing it.
    PASSWORD_STORE_CLIP_TIME = "45";

    # The path to the password store.
    PASSWORD_STORE_DIR = "${config.home.homeDirectory}/.password-store";

    # Enable using pass extensions.
    PASSWORD_STORE_ENABLE_EXTENSIONS = "true";

    # By default, make new passwords 32 characters long.
    PASSWORD_STORE_GENERATED_LENGTH = "32";
  };
}
