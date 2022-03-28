# Configuration for pipewire.
{ ...
}: {
  # Enable pipewire.
  services.pipewire.enable = true;
  services.pipewire.audio.enable = true;

  # Enable ALSA compatibility for pipewire.
  services.pipewire.alsa.enable = true;
  services.pipewire.alsa.support32Bit = true;

  # Configuration for the main pipewire daemon.
  services.pipewire.config.pipewire = {
    # Set the sample rate to 96kHz, rather than the default 48kHz.
    default.clock.rate = 96000;
  };

  # Enable JACK compatibility for pipewire.
  services.pipewire.jack.enable = true;

  # Enable PulseAudio compatibility for pipewire.
  services.pipewire.pulse.enable = true;

  # FIXME: try disabling services.pipewire.socketActivation if pipewire doesn't
  # start properly.
}
