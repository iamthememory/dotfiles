# Boot configuration.
{ ...
}: {
  imports = [
    ./grub.nix
  ];

  # Modules to ensure are in the initrd.
  boot.initrd.availableKernelModules = [
    # Ensure we can access SATA disks.
    "ahci"

    # Ensure we can access NVME devices.
    "nvme"

    # Ensure we can access SCSI devices.
    "sd_mod"

    # Ensure we can read SD cards.
    "sdhci_pci"

    # Ensure we can always access USB storage and USB SCSI.
    "uas"
    "usb_storage"

    # Ensure we can use USB keyboards and mice.
    "usbhid"

    # Ensure we are able to access USB devices.
    "xhci_pci"

    # Ensure we can access ext[234] filesystems.
    "ext2"
    "ext3"
    "ext4"

    # Ensure we can access FAT filesystems.
    "fat"
    "vfat"
  ];

  # Allow modifying UEFI variables to add the system to the boot configuration.
  boot.loader.efi.canTouchEfiVariables = true;
}
