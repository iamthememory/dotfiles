# GRUB configuration.
{ ...
}: {
  # Enable GRUB.
  boot.loader.grub.enable = true;

  # Enable encryption support in GRUB.
  boot.loader.grub.enableCryptodisk = true;

  # Enable UEFI support.
  boot.loader.grub.efiSupport = true;

  # Enable memtest86 entry in GRUB for checking RAM.
  boot.loader.grub.memtest86.enable = true;

  # Add other OSes os-prober finds to GRUB.
  boot.loader.grub.useOSProber = true;
}
