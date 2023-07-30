# htop configuration.
{ config
, pkgs
, ...
}: {
  # Manage htop configuration.
  programs.htop.enable = true;

  # Settings for htop.
  programs.htop.settings =
    let
      # The meters in the left side of the header.
      leftMeters = with config.lib.htop; config.lib.htop.leftMeters [
        (bar "AllCPUs2")
        (bar "CPU")
        (bar "Memory")
        (bar "Swap")
        (bar "PressureStallIOFull")
        (bar "Battery")
      ];

      # The meters in the right side of the header.
      rightMeters = with config.lib.htop; config.lib.htop.rightMeters [
        (text "Hostname")
        (text "Tasks")
        (text "LoadAverage")
        (text "DiskIO")
        (text "NetworkIO")
        (text "ZFSARC")
        (text "ZFSCARC")
        (text "Uptime")
        (text "Clock")
      ];
    in
    {
      # Show guest (VM) time in the CPU meters.
      account_guest_in_cpu_meter = true;

      # Use the "broken gray" color scheme, which works properly with
      # solarized-dark.
      color_scheme = 6;

      # Count CPUs starting at 0.
      cpu_count_from_one = false;

      # Update once a second.
      delay = 10;

      # Show a detailed CPU time breakdown in the CPU meters.
      detailed_cpu_time = true;

      # Enable using the mouse.
      enable_mouse = true;

      # The fields in the htop table.
      fields = with config.lib.htop.fields; [
        PID
        USER
        NICE
        IO_PRIORITY
        M_SIZE
        M_RESIDENT
        M_SHARE
        M_SWAP
        STATE
        PERCENT_CPU
        PERCENT_MEM
        TIME
        STARTTIME
        COMM
      ];

      # Try to find comm in the cmdline when Command is merged.
      find_comm_in_cmdline = true;

      # Don't put a margin between the headers and table to save space.
      header_margin = false;

      # Don't hide the function bar at the bottom.
      hide_function_bar = 0;

      # Hide threads by default.
      hide_kernel_threads = true;
      hide_threads = true;
      hide_userland_threads = true;

      # Highlight the basename of the running program.
      highlight_base_name = true;

      # Don't highlight new/dead processes by default, but if enabled, highlight
      # them for 5 seconds.
      highlight_changes = false;
      highlight_changes_delay_secs = 5;

      # Show amounts of memory above about a megabyte in a different color.
      highlight_megabytes = true;

      # Show threads in a different color.
      highlight_threads = true;

      # Shadow other users' processes by default.
      shadow_other_users = true;

      # Show the CPU frequency and usage percentages in the CPU bars.
      show_cpu_frequency = true;
      show_cpu_usage = true;

      # Don't merge exe, comm, and cmdline in the Command column.
      show_merged_command = false;

      # Show full program paths.
      show_program_path = true;

      # Show thread names.
      show_thread_names = true;

      # By default when not in tree view, sort by the CPU usage.
      sort_direction = 0;
      sort_key = config.lib.htop.fields.PERCENT_CPU;

      # Don't strip exe from cmdline when Command is merged.
      strip_exe_from_cmdline = false;

      # By default when in tree view, sort by PID.
      tree_sort_direction = 1;
      tree_sort_key = config.lib.htop.fields.PID;

      # Enable tree view by default.
      tree_view = true;

      # Don't always force tree view to sort by PID.
      tree_view_always_by_pid = false;

      # Don't update process names on every refresh.
      update_process_names = false;
    } // leftMeters // rightMeters;
}
