# Curses-like terminal utilities.
{ config
, inputs
, lib
, pkgs
, ...
}: {
  imports = [
    ./htop.nix
  ];

  home.packages = with pkgs; [
    # A tool for making project directories from templates.
    cookiecutter

    # An ncurses TUI for seeing what files take up how much space on disk.
    gdu

    # A resource monitor.
    glances

    # A tool that's like top for I/O.
    iotop

    # A pager for viewing files.
    less

    # A tool to see the space taken up by nix store gc-roots.
    nix-du

    # A TUI to browse the dependencies of a nix store path.
    nix-tree

    # Several important terminal utilities, like clear, infocmp, reset, tput,
    # etc. are provided directly by ncurses.
    # This is set to low priority so that any terminfo files installed by
    # terminals like st override the ones provided in ncurses.
    (lib.lowPrio ncurses)

    # A color-enabled info viewer.
    pinfo

    # A tool to show progress of other processes by monitoring their open file
    # descriptors.
    progress

    # A tool to show the I/O rate in a pipe.
    pv

    # A shinier, colorful df alternative.
    pydf

    # A TUI for viewing /sys nodes along with documentation.
    systeroid

    # A way of showing a directory tree as a tree diagram.
    tree
  ];

  # Let less output control characters for, e.g., coloring.
  home.sessionVariables.LESS = "-R";

  # Use less as the default pager.
  home.sessionVariables.PAGER = "${config.home.profileDirectory}/bin/less";

  # Enable bottom, a system monitor.
  programs.bottom.enable = true;

  # The settings for bottom.
  programs.bottom.settings = with inputs.lib.solarized.colorNames; {
    # Flags
    flags.average_cpu_row = true;
    flags.unnormalized_cpu = true;
    flags.battery = true;
    flags.process_memory_as_value = true;
    flags.network_use_binary_prefix = true;
    flags.network_use_log = true;
    flags.enable_cache_memory = true;

    # Disk settings.
    disk.mount_filter.is_list_ignored = true;
    disk.mount_filter.case_sensitive = true;
    disk.mount_filter.list = "\.zfs/snapshot";

    # CPU colors.
    styles.cpu.all_entry_color = base01;
    styles.cpu.avg_entry_color = base1;
    styles.cpu.cpu_core_colors = [
      yellow
      orange
      red
      magenta
      violet
      blue
      cyan
      green
    ];

    # Memory colors.
    styles.memory.ram_color = magenta;
    styles.memory.cache_color = red;
    styles.memory.swap_color = yellow;
    styles.memory.arc_color = cyan;
    styles.memory.gpu_colors = [
      violet
      blue
      green
      orange
    ];

    # Network colors.
    styles.network.rx_color = blue;
    styles.network.rx_total_color = green;
    styles.network.tx_color = yellow;
    styles.network.tx_total_color = red;

    # Battery colors.
    styles.battery.high_battery_color = green;
    styles.battery.medium_battery_color = yellow;
    styles.battery.low_battery_color = red;

    # Table style.
    styles.tables.headers.color = blue;
    styles.tables.headers.bold = true;

    # Graph style.
    styles.graphs.graph_color = base0;
    styles.graphs.legend_color = base1;

    # Widget style.
    styles.widgets.border_color = base02;
    styles.widgets.selected_border_color = violet;
    styles.widgets.widget_title.color = base2;
    styles.widgets.text.color = base1;
    styles.widgets.selected_text.color = violet;
    styles.widgets.selected_text.bg_color = base03;
    styles.widgets.disabled_text.color = base0;
    styles.widgets.thread_text.color = green;
  };

  # Enable fastfetch, a way of showing system information.
  programs.fastfetch.enable = true;

  # Enable lesspipe to transparently pre-process files fed to less.
  programs.lesspipe.enable = true;
}
