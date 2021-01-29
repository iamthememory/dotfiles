# Various system settings to specify things for, e.g., monitoring.
{ lib
, ...
}: with lib; {
  options = {
    system.monitor-mounts = mkOption {
      type = types.attrsOf (types.attrsOf (types.oneOf [
        types.int
        types.float
        types.str
      ]));

      default = { };

      description = ''
        An attribute set of mountpoints to monitor, with their names,
        mountpoints, and the warning/alert remaining space in GiB.
      '';

      example = literalExample ''
        {
          home = {
            mountpoint = "/home";
            alert = 20.0;
            warning = 40.0;
          };

          mail = {
            mountpoint = "/var/mail";
            alert = 8;
            warning = 16;
          };
        }
      '';
    };

    system.monitor-nvidia = mkOption {
      type = types.bool;

      default = false;

      description = ''
        Whether the system has an NVIDIA GPU to monitor.
        If this option is set, the system should provide
        <varname>nvidia-smi</varname> and <varname>nvidia-settings</varname> in
        the PATH, which NixOS should install if the NVIDIA drivers are selected.
        This is necessary since the userspace tools must match the kernel driver
        version.
      '';
    };
  };
}
