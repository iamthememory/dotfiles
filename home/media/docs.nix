# Packages and configuration for documents.
{ lib
, pkgs
, ...
}: {
  home.packages = with pkgs; [
    # Evince, for viewing PDFs and similar.
    evince

    # Libreoffice, for ODTs, Microsoft-y documents, presentations, spreadsheets,
    # etc.
    libreoffice-fresh
  ];

  # The default programs for opening various file types.
  xdg.mimeApps.defaultApplications =
    let
      # The settings for evince.
      evinceMimes =
        let
          # All MIMEs that evince should handle.
          mimes = [
            # PDF formats.
            "application/pdf"
            "application/x-bzpdf"
            "application/x-ext-pdf"
            "application/x-gzpdf"
            "application/x-xzpdf"

            # Postscript formats.
            "application/postscript"
            "application/x-bzpostscript"
            "application/x-ext-eps"
            "application/x-gzpostscript"
          ];
        in
        lib.genAttrs mimes (x: "org.gnome.Evince.desktop");
    in
    evinceMimes;
}
