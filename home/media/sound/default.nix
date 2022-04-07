# Sound-related media packages and configuration.
{ pkgs
, ...
}: {
  imports = [
    ./dev.nix
  ];

  home.packages = with pkgs; [
    # Tools for analyzing music files and submitting data on them to
    # AcousticBrainz.
    # Picard uses these.
    acousticbrainz-client
    essentia-extractor

    # A tool for tagging music files.
    picard
  ];

  # Enable easyeffects for effects on pipewire sound.
  services.easyeffects.enable = true;
}
