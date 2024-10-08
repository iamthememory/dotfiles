# Sound-related media packages and configuration.
{ pkgs
, ...
}: {
  imports = [
    ./dev.nix
  ];

  home.packages =
    let
      # Add some additional dependencies to gPodder.
      gpodder-custom = pkgs.gpodder.overrideAttrs (final: prev: {
        propagatedBuildInputs =
          with pkgs.python311Packages; prev.propagatedBuildInputs ++ [
            mutagen
            yt-dlp
          ];
      });
    in
    with pkgs; [
      essentia-extractor

      # A podcast manager.
      gpodder-custom

      # A tool for tagging music files.
      picard

      # Tools for working with OGG files and vorbis stuff.
      vorbis-tools
    ];

  # Enable easyeffects for effects on pipewire sound.
  services.easyeffects.enable = true;
}
