# Basic configuration for hosts.
{ config
, inputs
, lib
, pkgs
, ...
}: {
  # Clean /tmp on each boot.
  boot.cleanTmpDir = true;

  # Enable a rescue kernel to dump core if the kernel crashes.
  boot.crashDump.enable = true;

  # Extra sysctl options.
  boot.kernel.sysctl = {
    # Increase the number of inotify watches.
    "fs.inotify.max_user_watches" = 524288;

    # Restrict dmesg access to privileged users.
    "kernel.dmesg_restrict" = 1;

    # Increase the number of PIDs.
    # NOTE: This may need to be decreased for i686-linux.
    # FIXME: This should now be the default.
    #"kernel.pid_max" = 4194303;

    # Enable packet forwarding.
    "net.ipv4.ip_forward" = 1;

    # Decrease the willingness to swap out memory to keep more in RAM.
    "vm.swappiness" = 10;
  };

  # Link the current generation's source.
  environment.etc."generation".source = "${inputs.flake.sourceInfo}";

  # The current generation's revision.
  environment.etc."generation.rev".text =
    "${config.system.configurationRevision}";

  # Link the nixpkgs revision used for this generation to make building packages
  # from the same nixpkgs convenient for testing things.
  environment.etc."nixpkgs".source = "${pkgs.path}";

  # Extra PAM login limits.
  security.pam.loginLimits = [
    # Allow users in the wheel group to have more files open.
    {
      domain = "@wheel";
      item = "nofile";
      type = "soft";
      value = "1048576";
    }

    # Allow uses in the wheel group to raise the limit and open even more files.
    {
      domain = "@wheel";
      item = "nofile";
      type = "hard";
      value = "16777216";
    }
  ];

  # Enable chrony
  services.chrony.enable = true;

  # Chrony's configuration.
  # FIXME: When NTS-capable servers are more common, and we don't need a mix of
  # NTS and non-NTS servers, this should be reorganized as most of this won't be
  # necessary, since we can just set networking.timeServers to a number of
  # NTS-capable servers and set services.chrony.enableNTS.
  services.chrony.extraConfig =
    let
      # A set of servers that support NTS, preventing MITM attacks.
      ntsServers = [
        # Cloudflare's NTP server.
        "time.cloudflare.org"

        # The netnod NTP server.
        "nts.netnod.se"

        # The NTPsec servers.
        # FIXME: These may not always be available.
        "ntp1.glypnod.com"
        "ntp2.glypnod.com"
      ];
    in
    ''
      # The NTS-capable servers.
      ${lib.concatMapStringsSep "\n" (s: "server ${s} iburst nts") ntsServers}

      # The NixOS pool to pull extra servers from to prevent issues if some of
      # the NTS servers aren't available or are too far away.
      pool nixos.pool.ntp.org iburst maxsources 8

      # Only update the local clock if at least four sources are considered
      # good.
      minsources 4

      # Regularly update the RTC with the time.
      rtcsync

      # Where possible, tell the network interface's hardware to timestamp
      # exactly when packets are received/sent to increase accuracy.
      hwtimestamp *

      # When chrony starts during boot, quickly poll a couple servers for the
      # time.
      # If the clock is wrong by more than five minutes, step the clock to the
      # correct time rather than trying to slowly adjust it.
      # FIXME: This has to be manually put in the configuration since
      # services.chrony.servers is cleared.
      # It can probably be removed when NTS is more widely available for the
      # same reasons as above.
      initstepslew 300 0.nixos.pool.ntp.org 1.nixos.pool.ntp.org 2.nixos.pool.ntp.org 3.nixos.pool.ntp.org
    '';

  # Clear the default NTP servers, since we set some in the configuration
  # itself.
  # FIXME: This should be removed once there are enough NTS-capable servers to
  # add to networking.timeServers, which is what this defaults to.
  services.chrony.servers = [ ];

  # Regularly TRIM mounted partitions backed by SSDs in the background every few
  # days.
  services.fstrim.enable = true;

  # Enable fwupd for updating firmware.
  services.fwupd.enable = true;

  # Extra configuration for journald.
  services.journald.extraConfig = ''
    # Always try to store journal data between boots.
    Storage=persistent
  '';

  # Enable smartd for monitoring disk health.
  services.smartd.enable = true;

  # Enable tuptime to keep track of total uptime across boots.
  services.tuptime.enable = true;

  # The revision used to build this configuration.
  system.configurationRevision = inputs.flake.rev or "dirty";

  # The NixOS release this configuration is compatible with.
  # On new NixOS releases, bump this only after going through the release notes
  # and ensuring compatibility with any changes.
  system.stateVersion = "20.09";

  # Extra mount units for systemd.
  systemd.mounts =
    let
      # Overrides for the /tmp tmpfs mount.
      # Systemd gives a default 400k inodes, which isn't enough for building
      # some packages on /tmp.
      # Allow as many inodes as requested to be created.
      # This could technically fill RAM by filling /tmp with empty files, but
      # there are easier ways to hang a system if something can already run
      # arbitrary code/create millions of files.
      tmpMount = {
        # The device to mount.
        what = "tmpfs";

        # Where to mount it.
        where = "/tmp";

        # The filesystem type.
        type = "tmpfs";

        # Options for the filesystem.
        options =
          let
            options = [
              # Set the typical mode for /tmp.
              "mode=1777"

              # Enable updating access times, since there's no real penalty for
              # writing access times to a tmpfs like there is to a hard disk.
              "strictatime"

              # Don't allow setuid binaries.
              "nosuid"

              # Don't allow device nodes.
              "nodev"

              # Allow /tmp to take up up to 50% of RAM.
              "size=50%"

              # Allow as many inodes as needed.
              "nr_inodes=0"
            ];
          in
          builtins.concatStringsSep "," options;
      };
    in
    lib.optional config.boot.tmpOnTmpfs tmpMount;

  # Default to UTC.
  time.timeZone = lib.mkDefault "UTC";

  # Make ZSH the default shell.
  users.defaultUserShell = pkgs.zsh;
}
