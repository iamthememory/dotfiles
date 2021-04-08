# GRUB configuration.
{ config
, inputs
, pkgs
, ...
}: {
  # Enable GRUB.
  boot.loader.grub.enable = true;

  # The name to use for this configuration entry in GRUB.
  boot.loader.grub.configurationName =
    let
      # The hostname.
      inherit (config.networking) hostName;

      # The kernel version.
      kernelVersion = config.boot.kernelPackages.kernel.version;

      # The (short) revision of this configuration.
      configRevision = inputs.flake.shortRev or "dirty";

      # The last commit date of this configuration.
      configDate =
        let
          # The date, formatted nicely.
          formattedDate = pkgs.runCommand "revisionDate" { } ''
            ${pkgs.coreutils}/bin/date \
              --date="@${builtins.toString inputs.flake.lastModified}" \
              '+%Y-%m-%d %H:%M:%S%:z' > $out
          '';
        in
        pkgs.lib.removeSuffix "\n" (builtins.readFile formattedDate);
    in
    "${hostName} - ${configDate} (${configRevision}) [${kernelVersion}]";

  # Enable UEFI support.
  boot.loader.grub.efiSupport = true;

  # Enable encryption support in GRUB.
  boot.loader.grub.enableCryptodisk = true;

  # Enable memtest86 entry in GRUB for checking RAM.
  boot.loader.grub.memtest86.enable = true;

  # Add other OSes os-prober finds to GRUB.
  boot.loader.grub.useOSProber = true;

  # Add ZFS support to GRUB.
  boot.loader.grub.zfsSupport = true;
}
