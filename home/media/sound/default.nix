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
          with pkgs.python3Packages; prev.propagatedBuildInputs ++ [
            mutagen
            youtube-dl
          ];
      });
    in
    with pkgs; [
      # Tools for analyzing music files and submitting data on them to
      # AcousticBrainz.
      # Picard uses these.
      acousticbrainz-client
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
