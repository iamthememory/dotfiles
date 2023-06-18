# Hardware-specific configuration for nightmare
{ pkgs
, ...
}: {
  # Extra commands to run in early boot.
  boot.postBootCommands =
    let
      setpci = "${pkgs.pciutils}/bin/setpci";
    in
    ''
      # Raise the amount of time devices are allowed to hold the PCI bus.
      ${setpci} -v -d '*:*' latency_timer=b0

      # Allow the GPU to hold the PCI more than other devices besides the sound
      # card.
      ${setpci} -v -s 01:00.0 latency_timer=d0

      # Allow the sound card to hold the PCI bus as much as needed.
      ${setpci} -v -s 00:1f.3 latency_timer=ff
    '';

  # Update the CPU microcode.
  hardware.cpu.intel.updateMicrocode = true;

  # Support for the Flipper Zero.
  hardware.flipperzero.enable = true;

  # Allow hackrf access to users in the plugdev group.
  hardware.hackrf.enable = true;

  # Enable system76 hardware options.
  hardware.system76.enableAll = true;

  # Prefer increasing frequency to max slowly, rather than ramping up the CPU
  # frequency to maximum quickly when load increases.
  # With the intel_pstate driver, powersave should still be relatively close to
  # performance.
  powerManagement.cpuFreqGovernor = "powersave";

  # Enable TPM2 support.
  security.tpm2.enable = true;

  # Proactively adjust CPU state to keep its temperature within normal bounds,
  # rather than relying on firmware to forcibly throttle when passing the
  # maximum temperature.
  # This should give smoother performance under heavy load and try to avoid
  # passing the maximum temperature in the first place.
  services.thermald.enable = true;

  # Enable TLP for managing power usage on battery.
  services.tlp.enable = true;

  # Extra settings for TLP.
  services.tlp.settings = {
    # Always use the powersave governor.
    # Under the intel_pstate driver, the performance is still relatively close
    # to the performance governor, just ramps up to maximum frequency slightly
    # slower.
    CPU_SCALING_GOVERNOR_ON_AC = "powersave";
    CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

    # Always keep SATA links at max performance.
    # Not everything likes the actual SATA link repeatedly changing how
    # responsive it is, and this is mostly just a workaround for disks not
    # supporting APM anyway.
    SATA_LINKPWR_ON_AC = "max_performance";
    SATA_LINKPWR_ON_BAT = "max_performance";

    # USB devices to never try to suspend.
    USB_BLACKLIST =
      let
        usbIDs = [
          # Various HackRF USB IDs.
          "1d50:604b"
          "1d50:6089"
          "1d50:cc15"
          "1fc9:000c"
        ];
      in
      "\"${builtins.concatStringsSep " " usbIDs}\"";
  };

  # Extra packages with udev rules.
  services.udev.packages = with pkgs; [
    # Yubikey access rules.
    yubikey-personalization
  ];

  # Device settings for X11.
  services.xserver.deviceSection = ''
    # Extra features to try to enable for NVIDIA.
    # * 16 - Enable overvolting.
    # *  8 - Enable overclocking.
    # *  4 - Enable controlling GPU fan speed.
    #    2 - Try to initialize SLI when using GPUs with different amounts of
    #        memory.
    #    1 - Enable overclocking of older GPUs.
    Option "Coolbits" "28"

    # Enable dithering on the laptop display.
    Option "FlatPanelProperties" "DP-0: Dithering = Enabled"
  '';

  # Use a DPI of 96 in X11.
  services.xserver.dpi = 96;

  # Use the NVIDIA driver.
  services.xserver.videoDrivers = [
    "nvidia"
  ];

  # Enable support for wacom tablets.
  services.xserver.wacom.enable = true;
}
