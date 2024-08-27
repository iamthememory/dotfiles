# Sound settings for NixOS.
{ ...
}: {
  imports = [
    ./pipewire.nix
  ];

  # Extra sysctl options.
  boot.kernel.sysctl = {
    # Let the high-precision event timer do up to 2048 Hz.
    "dev.hpet.max-user-freq" = 2048;
  };

  # Load the MIDI and sequencer ALSA modules.
  boot.kernelModules = [
    "snd-seq"
    "snd-rawmidi"
  ];

  # Extra parameters for the kernel.
  boot.kernelParams = [
    # Force IRQ handlers to be threaded when possible.
    "threadirqs"
  ];

  # Extra patches for the kernel.
  boot.kernelPatches = [
    # Add more preemption points to the kernel to limit potential latency.
    {
      name = "Low-latency preemption config";
      patch = null;

      extraConfig = ''
        # Enable low-latency preemption.
        PREEMPT y

        # Disable the other preemption models.
        PREEMPT_NONE n
        PREEMPT_VOLUNTARY n
      '';
    }
  ];

  # Extra commands to run in early boot.
  boot.postBootCommands = ''
    # Let the realtime clock(s) do up to 2048 Hz rather than the default 32 Hz
    # or so.
    for rtc_max_freq in /sys/class/rtc/rtc[0-9]*/max_user_freq
    do
      # Make sure this exists, so that if there isn't a modern RTC we don't
      # attempt to write to the unexpanded path.
      if [ -e "$${rtc_max_freq}" ]
      then
        echo 2048 > "$${rtc_max_freq}"
      fi
    done
  '';

  # Extra PAM limit settings.
  security.pam.loginLimits = [
    # Allow audio users to lock memory and prevent it from being swapped out.
    # This is used to ensure JACK, pipewire, pulseaudio, etc. can lock memory to
    # share with each client.
    # NOTE: This is set to unlimited, since that's what the JACK NixOS module
    # sets.
    {
      domain = "@audio";
      item = "memlock";
      type = "-";
      value = "unlimited";
    }

    # Allow audio users to run processes at very high realtime priorities, to
    # enable JACK, pipewire, etc. to operate with minimal latency.
    # NOTE: This is set to 99, since that's what the JACK NixOS module sets.
    {
      domain = "@audio";
      item = "rtprio";
      type = "-";
      value = "99";
    }
  ];

  # Enable RealtimeKit to give realtime priority to things such as PulseAudio.
  security.rtkit.enable = true;

  # Extra udev rules.
  services.udev.extraRules = ''
    # Allow high-precision clock access to users in the audio group.
    KERNEL=="hpet", GROUP="audio"
    KERNEL=="rtc0", GROUP="audio"
  '';
}
