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

  # Use Firefox as the default browser.
  home.sessionVariables.BROWSER = "${profileBin}/firefox";

  # Use Firefox as the incognito browser.
  home.sessionVariables.BROWSER_PRIVATE =
    "${profileBin}/firefox --private-window";

  # Set Firefox as the default browser.
  xdg.mimeApps.defaultApplications =
    let
      inherit (lib) genAttrs;

      # The Desktop entry to use.
      browser = "firefox.desktop";

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
