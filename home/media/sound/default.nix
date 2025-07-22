# Sound-related media packages and configuration.
{ pkgs
, ...
}: {
  imports = [
    ./dev.nix
  ];

  home.packages = with pkgs; [
    essentia-extractor

    # A podcast manager.
    gpodder

    # A tool for tagging music files.
    picard

    # Tools for working with OGG files and vorbis stuff.
    vorbis-tools
  ];

  # Enable easyeffects for effects on pipewire sound.
  services.easyeffects.enable = true;
}
