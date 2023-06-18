# Configuration for pipewire.
{ ...
}: {
  # Configuration for the main pipewire daemon.
  environment.etc."pipewire/pipewire.d/99-custom-settings.conf".text = ''
    context.properties = {
      # Set the sample rate to 96kHz, rather than the default 48kHz.
      default.clock.rate = 96000
    }
  '';

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

  # FIXME: try disabling services.pipewire.socketActivation if pipewire doesn't
  # start properly.
}
