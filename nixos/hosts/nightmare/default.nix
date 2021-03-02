# NixOS settings for nightmare.
{ inputs
, ...
}: {
  imports = [
    ./disks.nix

    ../../boot
  ];

  # Copy kernels and initrds to the boot partitions.
  boot.loader.grub.copyKernels = true;

  # set the host id for nightmare.
  # this is needed for zfs.
  networking.hostId = "713119fe";

  # set the hostname for nightmare.
  networking.hostName = "nightmare";
}
