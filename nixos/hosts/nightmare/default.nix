# NixOS settings for nightmare.
{ config
, pkgs
, ...
}: {
  imports = [
    ./disks.nix
    ./hardware.nix
    ./nix.nix
    ./secrets
    ./users.nix

    ../../base.nix
    ../../bluetooth.nix
    ../../boot
    ../../docs.nix
    ../../games
    ../../gui.nix
    ../../network
    ../../network/networkmanager.nix
    ../../network/wireless.nix
    ../../nix.nix
    ../../printing.nix
    ../../sound
    ../../utils.nix
    ../../virt/compat.nix
    ../../virt/docker.nix
    ../../virt/libvirt.nix
    ../../zfs.nix
  ];

  # Extra module packages.
  boot.extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback.out ];

  # Extra kernel modules.
  boot.kernelModules = [
    "v4l2loopback"
    "snd-aloop"
  ];

  # Module settings.
  boot.extraModprobeConfig = ''
    # exclusive_caps: Skype, Zoom, Teams etc. will only show device when actually streaming
    # card_label: Name of virtual camera, how it'll show up in Skype, Zoom, Teams
    # https://github.com/umlaeute/v4l2loopback
    options v4l2loopback video_nr=9 exclusive_caps=1 card_label="OBS Virtual Camera"
  '';

  # Copy kernels and initrds to the boot partitions.
  boot.loader.grub.copyKernels = true;

  # Enable NTFS support.
  boot.supportedFilesystems = [
    "ntfs"
  ];

  # Mount a tmpfs on /tmp.
  boot.tmp.useTmpfs = true;

  # Enable debug info for packages.
  environment.enableDebugInfo = true;

  # Extra system-wide packages.
  environment.systemPackages = with pkgs; [
    android-tools
    config.boot.kernelPackages.v4l2loopback.bin
  ];

  # Enable NVIDIA GPU support inside docker containers.
  hardware.nvidia-container-toolkit.enable = true;

  # Extra UDP port ranges to allow through the firewall.
  networking.firewall.allowedUDPPortRanges = [
    # SS14.
    { from = 1212; to = 1212; }

    # KDE Connect connections.
    { from = 1714; to = 1764; }

    # Factorio
    { from = 34197; to = 34197; }

    # Vintagestory.
    { from = 42420; to = 42420; }
  ];

  # Extra TCP port ranges to allow through the firewall.
  networking.firewall.allowedTCPPortRanges = [
    # SS14.
    { from = 1212; to = 1212; }

    # KDE Connect connections.
    { from = 1714; to = 1764; }

    # Metasploit reverse shell connections.
    { from = 4433; to = 4436; }

    # Factorio
    { from = 34197; to = 34197; }

    # Vintagestory.
    { from = 42420; to = 42420; }
  ];

  # Set the host id for nightmare.
  # This is needed for zfs.
  networking.hostId = "713119fe";

  # Set the hostname for nightmare.
  networking.hostName = "nightmare";

  # Enable bcc for kernel tracing and such with eBPF.
  programs.bcc.enable = true;

  # A way to run unpatched binaries.
  programs.nix-ld.enable = true;

  # Enable systemtap for instrumenting the running kernel.
  programs.systemtap.enable = true;

  # Enable wireshark for capturing packets.
  programs.wireshark.enable = true;

  # Enable the GPS daemon.
  services.gpsd.enable = true;

  # Enable the PCSC-lite daemon.
  services.pcscd.enable = true;

  # Enable postgresql.
  services.postgresql.enable = true;

  # Enable the sysprof daemon to allow profiling multiple processes at once.
  services.sysprof.enable = true;

  # Enable sysstat to collect basic system statistics.
  services.sysstat.enable = true;

  # Enable the Tor daemon.
  services.tor.enable = true;

  # Enable Tor routing.
  services.tor.client.enable = true;

  # Enable Tor DNS resolver support.
  services.tor.client.dns.enable = true;

  # Enable the transparent Tor proxy port.
  services.tor.client.transparentProxy.enable = true;

  # Enable the control socket for Tor.
  services.tor.controlSocket.enable = true;

  # Enable the torsocks wrapper to force programs to send network data through
  # Tor.
  services.tor.torsocks.enable = true;

  # Enable the yubikey agent.
  services.yubikey-agent.enable = true;

  # Set the timezone.
  time.timeZone = "America/New_York";

  # Regularly prune unused docker images and storage.
  virtualisation.docker.autoPrune.enable = true;
}
