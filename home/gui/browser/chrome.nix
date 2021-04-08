# Chrome-like browser setup.
{ ...
}:
let
  # The Chromium and Chrome extensions to install.
  chromeExtensions = [
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

    # Tab Session Manager.
    "iaiomicjabeggjcfkbimgmglanimpnae"

    # Looper for YouTube.
    "iggpfpnahkgpnindfkdncknoldgnccdg"
  ];
in
{
  # Enable Chromium.
  programs.chromium.enable = true;

  # Enable our extensions for all Chrome-like browsers.
  programs.brave.extensions = chromeExtensions;
  programs.chromium.extensions = chromeExtensions;
}
