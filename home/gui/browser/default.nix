# GUI browser setup.
{ config
, lib
, ...
}:
let
  # The home profile binary directory.
  profileBin = "${config.home.profileDirectory}/bin";
in
{
  imports = [
    ./chrome.nix
    ./firefox.nix
  ];

  # Use Chromium as the default browser.
  home.sessionVariables.BROWSER = "${profileBin}/chromium-browser";

  # Use Chromium as the incognito browser.
  home.sessionVariables.BROWSER_PRIVATE =
    "${profileBin}/chromium-browser --incognito";

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
