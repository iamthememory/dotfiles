# ZFS configuration.
{ config
, ...
}: {
  # Use the latest kernel packages that're compatible with whatever version of
  # ZFS we're using.
  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;

  # Regularly scrub ZFS pools.
  services.zfs.autoScrub.enable = true;

  # Scrub pools monthly.
  services.zfs.autoScrub.interval = "monthly";

  # Enable znapzend for ZFS snapshotting.
  services.znapzend.enable = true;

  # Create missing destination datasets when replicating datasets.
  services.znapzend.autoCreation = true;

  # Enable sending compressed data.
  services.znapzend.features.compressed = true;

  # Keep destination datasets unmounted when receiving.
  services.znapzend.features.recvu = true;

  # Enable raw sending, to send encrypted datasets fully encrypted.
  services.znapzend.features.sendRaw = true;

  # Only use any znapzend setups configured via NixOS's configuration.
  services.znapzend.pure = true;
}
