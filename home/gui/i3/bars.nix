# i3status-rust configuration.
{ config
, lib
, pkgs
, ...
}:
let
  # Use the Font Awesome 4.x icons.
  icons = "awesome4";

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
          format = " $icon ${name} $available.eng(w:4,p:Gi) ";

          # The path to monitor.
          path = value.mountpoint;

          # Use GiB for the warning/alert values.
          alert_unit = "GB";

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
        {
          block = "music";

          # The format to use.
          format = " $icon{ $combo.str(max_w:32)|} $prev $play $next ";

          # Seek 15 seconds at a time when scrolling.
          seek_step_secs = 15;
        }

        # Show sound status.
        {
          block = "sound";

          # Use pulseaudio as the audio driver.
          # NOTE: This should also work for pipewire, since it exposes itself as a
          # pulseaudio server.
          driver = "pulseaudio";

          # The format to use.
          format = " $icon {$volume.eng(w:2)|N/A} ";

          # Show when headphones are used.
          headphones_indicator = true;

          # Don't set the volume above 130% by scrolling.
          max_vol = 130;

          # Show the volume even if muted.
          show_volume_when_muted = true;
        }

        # Show new mail.
        {
          block = "maildir";

          # The format to use.
          format = " $icon $status ";

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
          format = " $icon{ $network_icon|}{ $bat_icon $bat_charge|}{ $notif_icon $notif_count|} ";
        }

        # Show the battery status.
        rec {
          block = "battery";

          # The format for when charging or discharging.
          format = " $icon $percentage{ ($time)|}{ $power|} ";

          # The format for other modes the battery might be in.";
          empty_format = format;
          full_format = format;
          missing_format = " $icon N/A ";
          not_charging_format = format;

          # The percentages to use for various alert levels.
          info = 75;
          good = 50;
          warning = 40;
          critical = 25;
        }

        # Show the screen brightness.
        {
          block = "backlight";

          # The format to use.
          format = " $icon $brightness ";

          # Invert the icons order since it seems to show backwards for Nerd
          # Fonts.
          invert_icons = true;

          # The format when there's no backlight.
          missing_format = " $icon N/A ";
        }
      ] ++ mountBlocks ++ [
        # Show system uptime.
        {
          block = "uptime";

          # The format to use.
          format = " $icon $text ";

          # Update regularly.
          interval = 15;
        }

        # Show the current time.
        {
          block = "time";

          format = " $icon $timestamp.datetime(f:'%a %Y-%m-%d %H:%M:%S %:z') ";

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
        format = " $icon{ $barchart|}{ $utilization|}{ $frequency.eng(w:4)/$max_frequency.eng(w:4)|}{ $boost|} ";
      }

      # Show the CPU temperature.
      {
        block = "temperature";

        # Only use the coretemp for the CPUs.
        chip = "coretemp-*";

        # The format to use.
        format = " $icon $min / $average / $max ";
      }
    ] ++ (lib.optional config.system.monitor-nvidia
      # Show the GPU utilization.
      {
        block = "nvidia_gpu";

        # The format to use.
        format = " $icon{ $utilization|}{ $memory.eng(p:Mi,force_prefix:true)|}{ $temperature|}{ $clocks.eng(w:4)|}{ $power|} ";
      }
    ) ++ [
      # Show the system load.
      {
        block = "load";

        # The format to show.
        format = " $icon $1m.eng(w:4) $5m.eng(w:4) $15m.eng(w:4) ";
      }

      # Show RAM and swap usage.
      {
        block = "memory";

        # The format to show.
        format =
          let
            # Format a memory variable consistently.
            format = var: "$" + "${var}.eng(w:4,p:Gi,force_prefix:true)";

            # Format a memory variable without the unit.
            formatNoUnit = var: "$" + "${var}.eng(w:4,p:Gi,force_prefix:true,hide_prefix:true,hide_unit:true)";

            # The memory format.
            memory = "${formatNoUnit "mem_used"} (${formatNoUnit "mem_total_used"})/${format "mem_total"}";

            # The swap format.
            swap = "${formatNoUnit "swap_used"}/${format "swap_total"}";
          in
          " $icon ${memory} $icon_swap ${swap} ";
      }

      # Show the space used/available on /tmp, since that's usually a tmpfs.
      {
        block = "disk_space";

        # The path to monitor.
        path = "/tmp";

        # Show the amount used, rather than the amount available, since this
        # is actually in RAM.
        format = " $icon tmp $used.eng(w:4,p:Gi,hide_unit:true,hide_prefix:true)/$total.eng(w:4,p:Gi) ";

        # Warn when we use 10% of /tmp, and alert if we pass 20% used.
        # Since /tmp is usually a tmpfs for small stuff, if it ever passes a
        # significant size that's usually something to look at.
        warning = 90;
        alert = 80;
      }

      # Show the network information for the current default route interface.
      {
        block = "net";

        format =
          let
            speeds = " ^icon_net_down $speed_down.eng(w:3) ^icon_net_up $speed_up.eng(w:3)";
            interface_info = " @ {$ssid|N/A} ({$signal_strength @ $frequency|N/A}) $ip @ $device";
          in
          " $icon${speeds}${interface_info} ";
      }

      # Show the current network speed and ping.
      {
        block = "speedtest";

        # Force updates on right-click.
        click = [
          {
            button = "right";
            update = true;
          }
        ];

        # On an error, try again in a minute or so.
        error_interval = 60;

        # The format to use.
        format =
          let
            down = "^icon_net_down $speed_down.eng(w:4,u:B)";
            up = "^icon_net_up $speed_up.eng(w:4,u:B)";
          in
          " ^icon_ping {$ping ${down} ${up}|N/A}";

        # Update every 30 minutes.
        interval = 30 * 60;
      }
    ]);
  };
}
