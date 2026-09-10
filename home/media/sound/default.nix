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

  # A MIDI synthesizer.
  programs.timidity.enable = true;

  # A TUI PipeWire audio mixer.
  programs.wiremix.enable = true;

  # Enable easyeffects for effects on pipewire sound.
  services.easyeffects.enable = true;
}
