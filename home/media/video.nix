# Video-related packages and configuration.
{ pkgs
, ...
}: {
  home.packages = with pkgs; [
    # A video editor.
    kdePackages.kdenlive
  ];

  # Add mpv to the profile.
  programs.mpv.enable = true;

  # The scripts to include with mpv.
  programs.mpv.scripts = with pkgs.mpvScripts; [
    # A plugin to control mpv via MPRIS.
    mpris

    # A script to show preview thumbnails when seeking in a video.
    thumbnail
  ];

  # Custom keybindings for mpv.
  programs.mpv.bindings =
    let
      # The speed multiplier to use.
      # This is a quarter of a semitone.
      speedMultiplier = 1.0145453349375237;

    in
    {
      # Slow down playback.
      "[" = "multiply speed ${builtins.toString (1 / speedMultiplier)}";

      # Speed up playback.
      "]" = "multiply speed ${builtins.toString speedMultiplier}";

      # Set/unset looping the entire playlist or set of files supplied to mpv.
      "L" = "cycle-values loop-playlist \"inf\" \"no\"";

      # Set/unset looping the current single file.
      "F" = "cycle-values loop-file \"inf\" \"no\"";
    };

  # Configuration settings for mpv.
  programs.mpv.config = {
    # Select English as the default audio language.
    alang = "en";

    # Don't show embedded images in audio by default.
    # This prevents treating most songs with embedded album art as videos.
    audio-display = false;

    # Don't correct pitch when speeding up/slowing down by default.
    audio-pitch-correction = false;

    # Try to play audio files without gaps between them, but reopen the audio
    # device if different files have, e.g., different sample rates, rather
    # than keeping the initial, possibly low sample rate.
    gapless-audio = "weak";

    # When taking screenshots, save them as strongly compressed PNGs.
    screenshot-format = "png";
    screenshot-png-compression = 9;
  };

  # Enable obs-studio.
  programs.obs-studio.enable = true;

  # Plugins for obs-studio.
  programs.obs-studio.plugins = with pkgs.obs-studio-plugins; [
    # A plugin to do screen capture on wlroots-based wayland compositors.
    wlrobs
  ];
}
