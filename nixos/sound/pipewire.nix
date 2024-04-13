# Configuration for pipewire.
{ ...
}: {
  # Enable pipewire.
  services.pipewire.enable = true;
  services.pipewire.audio.enable = true;

  # Enable ALSA compatibility for pipewire.
  services.pipewire.alsa.enable = true;
  services.pipewire.alsa.support32Bit = true;

  # Enable JACK compatibility for pipewire.
  services.pipewire.jack.enable = true;

  # Enable PulseAudio compatibility for pipewire.
  services.pipewire.pulse.enable = true;

  # Configuration for the main pipewire daemon.
  services.pipewire.extraConfig.pipewire."99-custom-settings.conf" = {
    # Set the sample rate to 96kHz, rather than the default 48kHz.
    "context.properties"."default.clock.rate" = 96000;
  };

  # FIXME: try disabling services.pipewire.socketActivation if pipewire doesn't
  # start properly.
}
