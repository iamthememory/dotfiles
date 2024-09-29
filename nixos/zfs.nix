# ZFS configuration.
{ ...
}: {
  # Regularly scrub ZFS pools.
  services.zfs.autoScrub.enable = true;

  # Scrub pools monthly.
  services.zfs.autoScrub.interval = "monthly";

  # Enable znapzend for ZFS snapshotting.
  services.znapzend.enable = true;

  # Create missing destination datasets when replicating datasets.
  services.znapzend.autoCreation = true;

  # Keep destination datasets unmounted when receiving.
  services.znapzend.features.recvu = true;

  # Enable raw sending, to send encrypted datasets fully encrypted.
  services.znapzend.features.sendRaw = true;

  # Only use any znapzend setups configured via NixOS's configuration.
  services.znapzend.pure = true;
}
