# htop configuration.
{ pkgs
, ...
}: {
  # Manage htop configuration.
  programs.htop.enable = true;

  # Show guest (VM) time in the CPU meters.
  programs.htop.accountGuestInCpuMeter = true;

  # Use the "broken gray" color scheme, which works properly with
  # solarized-dark.
  programs.htop.colorScheme = 6;

  # Count CPUs starting at 0.
  programs.htop.cpuCountFromZero = true;

  # Update once a second.
  programs.htop.delay = 10;

  # Show a detailed CPU time breakdown in the CPU meters.
  programs.htop.detailedCpuTime = true;

  # The fields in the htop table.
  programs.htop.fields = [
    "PID"
    "CGROUP"
    "USER"
    "NICE"
    "IO_PRIORITY"
    "M_SIZE"
    "M_RESIDENT"
    "M_SHARE"
    "STATE"
    "PERCENT_CPU"
    "PERCENT_MEM"
    "TIME"
    "STARTTIME"
    "COMM"
  ];

  # Don't put a margin between the headers and table to save space.
  programs.htop.headerMargin = false;

  # Hide threads by default.
  programs.htop.hideKernelThreads = true;
  programs.htop.hideThreads = true;
  programs.htop.hideUserlandThreads = true;

  # Highlight the basename of the running program.
  programs.htop.highlightBaseName = true;

  # The meters in the left side of the header.
  programs.htop.meters.left = [
    "AllCPUs2"
    "CPU"
    "Memory"
    "Swap"
    { kind = "Battery"; mode = 1; }
  ];

  # The meters in the right side of the header.
  programs.htop.meters.right = [
    "Hostname"
    "Tasks"
    "LoadAverage"
    "Uptime"
    "Clock"
  ];

  # SHadow other users' processes by default.
  programs.htop.shadowOtherUsers = true;

  # Show full program paths.
  programs.htop.showProgramPath = true;

  # Show thread names.
  programs.htop.showThreadNames = true;

  # By default, show processes in a tree.
  programs.htop.treeView = true;
}
