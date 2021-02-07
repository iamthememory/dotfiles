# i3status-rust configuration.
{ config
, inputs
, lib
, pkgs
, ...
}:
let
  # Use the Font Awesome 4.x icons.
  # NOTE: These are patched into Nerd Fonts, so we can use them.
  # At the moment, the Font Awesome 5.x icons aren't though, as far as I can
  # tell.
  icons = "awesome";

  # Other i3status-rust settings.
  settings = { };

  # Use the solarized dark theme.
  theme = "solarized-dark";

  # Override i3status-rust to build it from the master branch.
  # FIXME: Remove this and use the version in nixpkgs once
  # https://github.com/greshake/i3status-rust/pull/972
  # is in a released version.
  i3status-rust = pkgs.i3status-rust.overrideAttrs (oldAttrs: rec {
    version = inputs.i3status-rust.lastModifiedDate;
    name = "${oldAttrs.pname}-${version}";

    src = inputs.i3status-rust;

    buildInputs = oldAttrs.buildInputs ++ [
      pkgs.pkgsStatic.openssl
    ];

    cargoDeps = oldAttrs.cargoDeps.overrideAttrs (lib.const {
      name = "${name}-vendor.tar.gz";
      inherit src;
      outputHash = "pgZQ3FfN1xVXpqI6CXTjD+Od+mN2VTBvMO7C/r7iqfU=";
    });
  });
in
{
  home.packages = with pkgs; [
    # Ensure all the requirements for the network block are available.
    ethtool
    iputils
    iw
    networkmanager

    # The speedtest block needs speedtest.
    speedtest-cli

    # The temperature block needs lm_sensors.
    lm_sensors
  ];

  # Enable i3status-rust.
  programs.i3status-rust.enable = true;

  # Use the updated i3status-rust from master.
  programs.i3status-rust.package = i3status-rust;

  # The configuration for the bottom bar, from left to right.
  programs.i3status-rust.bars.bottom = {
    inherit icons settings theme;

    # The blocks for this bar.
    blocks =
      let
        # Given a mountpoint option, generate the disk block.
        mkDiskBlock = name: value: {
          block = "disk_space";

          # The name to display
          alias = name;

          # The path to monitor.
          path = value.mountpoint;

          # Use GiB as the unit.
          unit = "GiB";

          # Use GiB for the warning/alert values.
          alert_absolute = true;

          # The alert and warning available space.
          alert = value.alert;
          warning = value.warning;
        };

        # The blocks for mountpoints.
        mountBlocks =
          lib.mapAttrsToList mkDiskBlock config.system.monitor-mounts;
      in
      lib.mkDefault ([
        # Show the currently playing media.
        # This can be cycled by right-clicking.
        {
          block = "music";

          # Show all control buttons.
          buttons = [
            "prev"
            "play"
            "next"
          ];

          # The format to use.
          format = "{combo} ({avail})";

          # Don't rotate/marquee text if it doesn't fit.
          marquee = false;

          # The maximum width of the block.
          max_width = 32;
        }

        # Show sound status.
        {
          block = "sound";

          # Use pulseaudio as the audio driver.
          # NOTE: This should also work for pipewire, since it exposes itself as a
          # pulseaudio server.
          driver = "pulseaudio";

          # The format to use.
          format = "{volume}%";

          # Don't set the volume above 130% by scrolling.
          # That's still probably too high, but it's better than nothing.
          max_vol = 130;

          # Show the volume even if muted.
          show_volume_when_muted = true;
        }

        # Show new mail.
        {
          block = "maildir";

          # The inboxes to check.
          inboxes =
            let
              # Given an account, get the inbox path.
              inbox = name: value:
                let
                  # Mailbox base path.
                  basePath = "${config.accounts.email.maildirBasePath}/${name}";
                in
                "${basePath}/${value.folders.inbox}";

              # The individual boxes.
              inboxes =
                lib.mapAttrsToList inbox (config.accounts.email.accounts or [ ]);
            in
            inboxes;

          # Update every minute.
          interval = 60;
        }

        # Show KDEconnect info.
        {
          block = "kdeconnect";

          # The format to use.
          format = "{bat_icon}{bat_charge}% {notif_icon}{notif_count}";
        }

        # Show the battery status.
        {
          block = "battery";

          # The format for when charging or discharging.
          format = "{percentage}% ({time})";

          # The format to use when the battery is full.
          full_format = "{percentage}%";

          # The percentages to use for various alert levels.
          info = 75;
          good = 50;
          warning = 40;
          critical = 25;
        }

        # Show the screen brightness.
        {
          block = "backlight";
        }

      ] ++ mountBlocks ++ [

        # Show system uptime.
        {
          block = "uptime";
        }

        # Show the current time.
        {
          block = "time";

          format = "%a %Y-%m-%d %H:%M:%S";

          # Update twice a second.
          interval = 0.5;
        }
      ]);
  };

  # The configuration for the top bar, from left to right.
  programs.i3status-rust.bars.top = {
    inherit icons settings theme;

    # The blocks for this bar.
    blocks = lib.mkDefault ([
      # Show the CPU utilization.
      {
        block = "cpu";

        # The format to use.
        format = "{barchart} {utilization}% {frequency}GHz";
      }

      # Show the CPU temperature.
      {
        block = "temperature";

        # Don't collapse by default.
        collapsed = false;
      }

    ] ++ (lib.optional config.system.monitor-nvidia
      # Show the GPU utilization.
      {
        block = "nvidia_gpu";

        # Show clock speeds.
        show_clocks = true;
      }
    ) ++ [

      # Show the system load.
      {
        block = "load";

        # The format to show.
        format = "{1m} {5m} {15m}";
      }

      # Show RAM usage.
      {
        block = "memory";

        # Lock this to RAM mode.
        display_type = "memory";
        clickable = false;

        # The format to show.
        format_mem = "{Mug}/{MTg} GiB";
      }

      # Show swap usage.
      {
        block = "memory";

        # Lock this to swap mode.
        display_type = "swap";
        clickable = false;

        # The format to show.
        format_swap = "{SUg}/{STg} GiB";
      }

      # Show the network information for the current default route interface.
      {
        block = "net";

        # The format to show.
        format =
          let
            # The format to use for the speed.
            speed = "{speed_up} {speed_down}";
          in
          "${speed} @ {ssid} ({signal_strength}) {ip}";
      }

      # Show the current network speed and ping.
      {
        block = "speedtest";

        # Show units in bytes.
        bytes = true;

        # Update every 30 minutes.
        interval = 30 * 60;
      }
    ]);
  };
}
