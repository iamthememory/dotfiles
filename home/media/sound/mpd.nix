# Configuration for MPD.
{ config
, pkgs
, ...
}:
let
  mpd-visualizer-fifo = "/tmp/mpd-visualizer-${config.home.username}.fifo";
in
{
  home.packages = with pkgs; [
    # A small script-friendly MPD client.
    mpc
  ];

  # Enable ncmpcpp as a MPD client.
  programs.ncmpcpp.enable = true;

  # Enable the visualizer in ncmpcpp.
  programs.ncmpcpp.package = pkgs.ncmpcpp.override {
    visualizerSupport = true;
  };

  # Use the same editor we use for everything else for editing lyrics.
  programs.ncmpcpp.settings.external_editor = config.home.sessionVariables.EDITOR;

  # Organize the ncmpcpp media library by album artist, rather than artist.
  programs.ncmpcpp.settings.media_library_primary_tag = "album_artist";

  # Enable the ncmpcpp visualizer.
  programs.ncmpcpp.settings.visualizer_data_source = mpd-visualizer-fifo;
  programs.ncmpcpp.settings.visualizer_in_stereo = true;
  programs.ncmpcpp.settings.visualizer_output_name = "Visualizer FIFO";

  # Enable MPD.
  services.mpd.enable = true;

  # Extra MPD configuration.
  services.mpd.extraConfig = ''
    # Pause when restarting MPD.
    restore_paused "yes"

    # Disable zeroconf service publishing.
    zeroconf_enabled "no"

    # Use pipewire for output.
    audio_output {
      type "pipewire"
      name "Pipewire Output"
    }

    # Add a FIFO for ncmpcpp's visualizer.
    audio_output {
      type "fifo"
      name "Visualizer FIFO"
      path "${mpd-visualizer-fifo}"
      format "44100:16:2"
    }

    # Disable decoding MP3s with libmad.
    # For some reason this seems to cause crackling?
    decoder {
      plugin "mad"
      enabled "no"
    }

    # Enable the input cache.
    input_cache {
      size "512 MB"
    }

    # Use libsamplerate as the resampler.
    resampler {
      plugin "libsamplerate"
      # Use the highest quality for resampling.
      type "0"
    }
  '';

  # Enable mpDris2 to notify programs what MPD is playing via MPRIS2.
  services.mpdris2.enable = true;
}
