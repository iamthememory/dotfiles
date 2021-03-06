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

  # The configuration for the bottom bar, from left to right.
  programs.i3status-rust.bars.bottom = {
    inherit icons settings theme;

    # The blocks for this bar.
    blocks =
      let
        # Given a mountpoint option, generate the disk block.
        mkDiskBlock = name: value: {
          block = "disk_space";

          # The format to display.
          format = "${name} {available:6;G*_B} GiB";

          # The path to monitor.
          path = value.mountpoint;

          # Use GiB as the unit.
          unit = "GB";

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
          format = "{volume}";

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
          format = "{bat_icon}{bat_charge} {notif_icon}{notif_count}";
        }

        # Show the battery status.
        {
          block = "battery";

          # The format for when charging or discharging.
          format = "{percentage} ({time})";

          # The format to use when the battery is full.
          full_format = "{percentage}";

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
        format = "{barchart} {utilization} {frequency}";
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
        format = "{1m:4} {5m:4} {15m:4}";
      }

      # Show RAM usage.
      {
        block = "memory";

        # Lock this to RAM mode.
        display_type = "memory";
        clickable = false;

        # The format to show.
        format_mem = "{mem_used:4;G*_B} ({mem_total_used:4;G*_B})/{mem_total:4;G*_B} GiB";
      }

      # Show swap usage.
      {
        block = "memory";

        # Lock this to swap mode.
        display_type = "swap";
        clickable = false;

        # The format to show.
        format_swap = "{swap_used:4;G*_B}/{swap_total:4;G*_B} GiB";
      }

      # Show the space used/available on /tmp, since that's usually a tmpfs.
      {
        block = "disk_space";

        # The name to display.
        alias = "tmp";

        # The path to monitor.
        path = "/tmp";

        # Use GiB as the unit.
        unit = "GB";

        # Show the amount used, rather than the amount available, since this
        # is actually in RAM.
        format = "{alias} {used:4;G*_B}/{total:4;G*_B} GiB";

        # Warn when we use 10% of /tmp, and alert if we pass 20% used.
        # Since /tmp is usually a tmpfs for small stuff, if it ever passes a
        # significant size that's usually something to look at.
        alert_absolute = false;
        warning = 90;
        alert = 80;
      }

      # Show the network information for the current default route interface.
      {
        block = "net";

        # The format to show.
        format =
          let
            # The format to use for the speed.
            speed = "{speed_up:3} {speed_down:3}";
          in
          "${speed} @ {ssid:12^12} ({signal_strength:3}) {ip:15}";
      }

      # Show the current network speed and ping.
      {
        block = "speedtest";

        # Update every 30 minutes.
        interval = 30 * 60;
      }
    ]);
  };
}
