# Basic media utilities.
{ pkgs
, ...
}: {
  home.packages = with pkgs; [
    # A tool for converting and manipulating media files.
    ffmpeg

    # A tool for manipulating images.
    imagemagick

    # A tool for manipulating sound files.
    sox
  ];
}
