# Disk configuration for nightmare.
{ config
, lib
, ...
}:
let
  # Make an ext4 entry from the given UUID.
  mkExt4 = uuid: {
    device = "/dev/disk/by-uuid/${uuid}";
    fsType = "ext4";
  };

  # Make a tmpfs entry.
  mkTmpfs = {
    device = "none";
    fsType = "tmpfs";
  };

  # Make a vfat entry from the given UUID, for UEFI filesystems.
  mkVfat = uuid: {
    device = "/dev/disk/by-uuid/${uuid}";
    fsType = "vfat";
  };

  # Make a ZFS filesystem entry from the given device name.
  mkZFS = device: {
    inherit device;
    fsType = "zfs";
  };
in
{
  # Use the first mirrored UEFI as the default UEFI mount point.
  boot.loader.efi.efiSysMountPoint = "/boot0/efi";

  # The boot and UEFI partitions to mirror GRUB to.
  boot.loader.grub.mirroredBoots =
    let
      # The boot mountpoints.
      bootMountPoints = [
        "/boot0"
        "/boot1"
      ];

      # Make a UEFI mirrored boot entry for the given boot partition.
      mkEntry = bootMountPoint: {
        # This must be set to nodev to disable trying to install BIOS-y MBR-y
        # bootloader code.
        devices = [ "nodev" ];

        # The UEFI mointpoint for this disk.
        efiSysMountPoint = "${bootMountPoint}/efi";

        # The boot mountpoint for this disk.
        path = bootMountPoint;
      };
    in
    (builtins.map mkEntry bootMountPoints);

  # LUKS devices to open.
  boot.initrd.luks.devices =
    let
      # All LUKS devices on nightmare.
      devices = [
        # SSD boot mirror 0.
        {
          uuid = "4ae6a235-3856-4134-83fb-8b66cdd41aca";
          allowDiscards = true;
        }

        # SSD boot mirror 1.
        {
          uuid = "9dbd677e-023f-4e81-92fa-15d7b7cf479b";
          allowDiscards = true;
        }


        # SSD ZFS pool spool mirror vdev 0.
        {
          uuid = "1ad26a74-07b5-45ec-a9e1-5df0aa51d9e0";
          allowDiscards = true;
          bypassWorkqueues = true;
        }

        # SSD ZFS pool spool mirror vdev 1.
        {
          uuid = "58fc5413-b912-449d-96ea-684b6c6eb5ca";
          allowDiscards = true;
          bypassWorkqueues = true;
        }


        # Hard disk ZFS pool rpool mirror vdev 0.
        "79808dc3-3315-4a24-a99a-4231e2ca2677"

        # Hard disk ZFS pool rpool mirror vdev 1.
        "7d18d2a1-9822-4775-ba1f-f75fba52bea5"
      ];

      # Given a device's info, make its LUKS entry.
      mkLuksEntry = entry:
        let
          # The LUKS UUID.
          luksUUID =
            if builtins.isString entry
            then entry
            else entry.uuid;

          # Whether or not to allow discards.
          allowDiscards =
            if builtins.isString entry
            then false
            else entry.allowDiscards or false;
        in
        {
          name = "luks-${luksUUID}";
          value = {
            device = "/dev/disk/by-uuid/${luksUUID}";
            inherit allowDiscards;
          };
        };
    in
    builtins.listToAttrs (builtins.map mkLuksEntry devices);

  # Prompt for encryption keys/passphrases when importing the pools for the
  # encryption roots of datasets.
  boot.zfs.requestEncryptionCredentials = [
    "spool/enc"
    "rpool/enc"
  ];

  # Configuration for fwupd's UEFI support.
  # FIXME: Remove this once NixOS fixes that it puts the UEFI partition info in
  # fwupd/uefi.conf instead of fwupd/uefi_capsule.conf.
  environment.etc."fwupd/uefi_capsule.conf" = lib.mkForce {
    text = lib.generators.toINI { } {
      # Use the first EFI mount point for fwupd.
      uefi.OverrideESPMountPoint = "/boot0/efi";
    };
  };

  # Boot filesystems.
  fileSystems."/boot0" = mkExt4 "a1efbceb-f1ae-493a-ab75-6765a8a1961b";
  fileSystems."/boot0/efi" = mkVfat "7EC6-BF71";
  fileSystems."/boot1" = mkExt4 "cb5fae85-7483-4fd3-8eeb-b1441fb15a7d";
  fileSystems."/boot1/efi" = mkVfat "DD67-7023";

  # System filesystems.
  fileSystems."/" = mkZFS "spool/enc/nixos";
  fileSystems."/home" = mkZFS "spool/enc/shared/home";
  fileSystems."/nix" = mkZFS "spool/enc/nixos/nix";
  fileSystems."/opt" = mkZFS "spool/enc/nixos/opt";
  fileSystems."/srv" = mkZFS "rpool/enc/nixos/srv";
  fileSystems."/usr" = mkZFS "spool/enc/nixos/usr";
  fileSystems."/var" = mkZFS "spool/enc/nixos/var";
  fileSystems."/var/cache" = mkZFS "rpool/enc/nixos/var/cache";
  fileSystems."/var/lib" = mkZFS "rpool/enc/nixos/var/lib";
  fileSystems."/var/lib/docker" = mkZFS "rpool/enc/nixos/var/lib/docker";
  fileSystems."/var/log" = mkZFS "rpool/enc/nixos/var/log";
  fileSystems."/var/tmp" = mkZFS "rpool/enc/nixos/var/tmp";
  fileSystems."/var/tmp/ram" = mkTmpfs;

  # Data filesystems.
  fileSystems."/data" = mkZFS "rpool/enc/shared/data";
  fileSystems."/data/downloads" = mkZFS "rpool/enc/shared/data/downloads";
  fileSystems."/data/ebook" = mkZFS "rpool/enc/shared/data/ebook";
  fileSystems."/data/music" = mkZFS "rpool/enc/shared/data/music";
  fileSystems."/data/music.old" = mkZFS "rpool/enc/shared/data/music.old";
  fileSystems."/data/src" = mkZFS "rpool/enc/shared/data/src";
  fileSystems."/var/cache/ccache" = mkZFS "rpool/enc/nixos/var/cache/ccache";
  fileSystems."/var/cache/spotify" = mkZFS "rpool/enc/nixos/var/cache/spotify";

  # Game filesystems.
  fileSystems."/opt/bottles" = mkZFS "spool/enc/shared/opt/bottles";
  fileSystems."/opt/ffxiv" = mkZFS "spool/enc/shared/opt/ffxiv";
  fileSystems."/opt/itch" = mkZFS "spool/enc/shared/opt/itch";
  fileSystems."/opt/lutris" = mkZFS "spool/enc/shared/opt/lutris";
  fileSystems."/opt/steam" = mkZFS "spool/enc/shared/opt/steam";

  # Pool mountpoints to check pool free space with tools that don't specially
  # check zfS pools.
  fileSystems."/rpool" = mkZFS "rpool";
  fileSystems."/spool" = mkZFS "spool";

  # Znapzend ZFS snapshotting configuration for different ZFS datasets.
  services.znapzend.zetup =
    let
      # The default ZFS snapshotting plan.
      # Save hourly snapshots for a week, daily snapshots for a month, weekly
      # snapshots for three months.
      defaultPlan = "1w=>1h,1m=>1d,3m=>1w";

      # A simple snapshotting plan that only keeps enough snapshots to keep
      # around a directory structure.
      structurePlan = "1d=>6h";

      # Make the snapshot configuration for a znapzend entry.
      mkZetup = entry:
        let
          # The dataset name.
          dataset =
            if builtins.isString entry
            then entry
            else entry.dataset;

          # The caching plan to use.
          plan =
            if builtins.isString entry
            then defaultPlan
            else entry.plan or defaultPlan;

          inherit (config.networking) hostName;
        in
        {
          # The name of this dataset.
          name = dataset;

          value = {
            inherit dataset plan;

            # Enable snapshotting on this dataset.
            enable = true;

            # Backup this dataset to an external USB disk.
            destinations.externalusb.dataset = "bpool/${hostName}/${dataset}";

            # Don't snapshot recursively.
            recursive = false;

            # The format to use for the snapshot names.
            timestampFormat = "znapzend-%Y-%m-%d-%H:%M:%SZ";
          };
        };

      # The datasets to snapshot.
      datasets = [
        "rpool/enc/nixos/srv"
        "rpool/enc/nixos/var/cache"
        "rpool/enc/nixos/var/cache/ccache"
        "rpool/enc/nixos/var/cache/spotify"
        "rpool/enc/nixos/var/lib"
        "rpool/enc/nixos/var/log"
        "rpool/enc/shared/data"
        "rpool/enc/shared/data/downloads"
        "rpool/enc/shared/data/ebook"
        "rpool/enc/shared/data/music"
        "rpool/enc/shared/data/music.old"
        "rpool/enc/shared/data/src"
        "spool/enc/nixos"
        "spool/enc/nixos/opt"
        "spool/enc/nixos/usr"
        "spool/enc/nixos/var"
        "spool/enc/shared/home"
        "spool/enc/shared/opt/bottles"
        "spool/enc/shared/opt/ffxiv"
        "spool/enc/shared/opt/lutris"
      ];
    in
    builtins.listToAttrs (builtins.map mkZetup datasets);

  # Swap partitions.
  swapDevices = [
    # spool/swap.
    {
      device = "/dev/disk/by-uuid/ef9cb187-471a-4893-91d8-6b11b7a0e12f";
      discardPolicy = "both";
    }
  ];

  # Use ZFS as the storage backend for Docker.
  virtualisation.docker.storageDriver = "zfs";
}
