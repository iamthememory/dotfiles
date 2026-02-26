# Image-related packages and configuration.
{ inputs
, lib
, pkgs
, ...
}: {
  home.packages = with pkgs; [
    # A raster image editor.
    gimp

    # An image viewer.
    eog

    # A vector image editor.
    inkscape

    # A digital art program.
    inputs.stable.krita

    # Another image viewer, which has replaced eog upstream.
    loupe

    # A comic reader.
    #mcomix

    # A utility to optimize PNGs to the smaller sizes without sacrificing
    # quality.
    pngcrush
  ];

  # The default programs for opening various file types.
  xdg.mimeApps.defaultApplications =
    let
      # The settings for eog.
      eogMimes =
        let
          # All MIMEs that evince should handle.
          mimes = [
            # Bitmap images.
            "image/bmp"

            # GIFs.
            "image/gif"

            # JPEGs.
            "image/jpeg"
            "image/jpg"

            # PNGs.
            "image/png"

            # TIFFs.
            "image/tiff"
          ];
        in
        lib.genAttrs mimes (x: "org.gnome.eog.desktop");
    in
    eogMimes;
}
