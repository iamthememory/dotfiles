# Basic terminal hardware utilities.
{ pkgs
, ...
}: {
  home.packages = with pkgs; [
    # A utility for rescuing disk data with progress (and also useful for
    # writing USBs without using the kernel buffering which for slow USB 2.0
    # disks can grind system I/O to a halt with large enough disk images to
    # write).
    ddrescue

    # Tools for manipulating FAT filesystems.
    dosfstools

    # A tool for manipulating GPT partitions.
    gptfdisk

    # A tool for enumerating and showing basic hardware info.
    hwinfo

    # A tool for manipulating Squashfs filesystems.
    squashfsTools

    # USB utilities like lsusb.
    usbutils

    # PCI(e) utilities like lspci.
    pciutils
  ];
}
