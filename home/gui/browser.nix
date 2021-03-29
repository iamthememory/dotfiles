# GUI browser setup.
{ config
, lib
, ...
}:
let
  # The Chromium and Chrome extensions to install.
  extensions = [
    # Adblock Plus.
    "cfhdojbkjhnklbpkdaibdccddilifddb"

    # Stylus.
    "clngdbkpkpeebahjckkjfobafhncgmne"

    # Vimium.
    "dbepggeogbaibhgnhhndojpepiihcmeb"

    # Tampermonkey.
    "dhdgffkkebhmkfjojejmpbldmpobfkfo"

    # Downloads Router.
    "fgkboeogiiklpklnjgdiaghaiehcknjo"

    # HTTPS Everywhere.
    "gcbommkclmclpchllfjekcdonpmejbdp"

    # Google Docs Offline.
    "ghbmnnjooekpmoecnnnilnnbdlolhkhi"

    # Allow Right-Click.
    "hompjdfbfmmmgflfjdlnkohcplmboaeo"

    # Looper for YouTube.
    "iggpfpnahkgpnindfkdncknoldgnccdg"
  ];

  # The home profile binary directory.
  profileBin = "${config.home.profileDirectory}/bin";
in
{
  # Use Chromium as the default browser.
  home.sessionVariables.BROWSER = "${profileBin}/chromium-browser";

  # Use Chromium as the incognito browser.
  home.sessionVariables.BROWSER_PRIVATE =
    "${profileBin}/chromium-browser --incognito";

  # Enable Chromium.
  programs.chromium.enable = true;

  # Enable the binary Google Chrome for testing and DRM purposes.
  programs.google-chrome.enable = true;

  # Enable our extensions for all Chrome-like browsers.
  programs.brave.extensions = extensions;
  programs.chromium.extensions = extensions;

  # Set Chromium as the default browser.
  xdg.mimeApps.defaultApplications =
    let
      inherit (lib) genAttrs;

      # The Desktop entry to use.
      browser = "chromium-browser.desktop";

      # All MIMEs to set.
      mimes = [
        # (X)HTML files.
        "application/xhtml+xml"
        "application/xhtml_xml"
        "text/html"

        # FTP links.
        "x-scheme-handler/ftp"

        # HTTP(S) links.
        "x-scheme-handler/http"
        "x-scheme-handler/https"
      ];
    in
    genAttrs mimes (x: browser);
}
