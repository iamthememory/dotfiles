{ config, lib, options, ... }:
let
  inherit (import ./channels.nix) stable unstable jellyfish staging master;

  scripts = import ./scripts { inherit config; };

  speedswapper = scripts.speedswapper;

  hostinfo = import ./hostid.nix;

  ibus-full = unstable.ibus-with-plugins.override {
    plugins = with unstable.ibus-engines; [
      anthy
      kkc
      m17n
      mozc
      table
      table-others
      typing-booster
      uniemoji
    ];
  };
in
  rec {
    imports = [
      ./ctags
      ./games
      ./gui
      ./vim
      ./zsh
    ];

    home = {
      file = {
        # FIXME.
      };

      extraOutputsToInstall = [
        "bin"
        "debug"
        "devdoc"
        "doc"
        "info"
        "man"
      ];

      keyboard = {
        layout = "us";

        model = "evdev";

        options = [
          "caps:swapescape"
          "compose:lwin"
          "numpad:mac"
        ];
      };

      language = {
        base = "en_US.UTF-8";
      };

      packages = with unstable; [
        R
        wireguard-tools
        acct
        ack
        acpi
        ag
        agrep
        aircrack-ng
        androidenv.androidPkgs_9_0.platform-tools
        appimage-run
        aria2
        avahi
        bashInteractive
        bc
        binutils
        bitcoin
        blueman
        bumpversion
        bzip2
        cargo
        config.programs.chromium.package
        chrony
        clang-tools
        cloc
        stable.cookiecutter
        coreutils
        curl
        dbus
        ddrescue
        diceware
        dnsutils
        docker
        dos2unix
        dosfstools
        dot2tex
        dunst
        ent
        evince
        ffmpeg
        file
        gcc
        gdb
        gimp
        git-lfs
        gitAndTools.gitflow
        gitFull
        gksu
        gnome3.adwaita-icon-theme
        gnome3.eog
        gnome3.gcr
        gnome3.gnome-disk-utility
        gnome3.nautilus
        gnome3.networkmanagerapplet
        gnome3.seahorse
        gnome3.zenity
        gnucash
        gnugrep
        gnumake
        gnupg
        gnuplot
        gnutar
        gptfdisk
        graphviz
        gzip
        host
        httpie
        i3
        ibus-full
        imagemagick
        inkscape
        iotop
        stable.jack2
        jq
        keybase-gui
        libisoburn
        libnotify
        #libreoffice-fresh
        lightdm
        lightdm_gtk_greeter
        links
        linuxPackages.systemtap
        lm_sensors
        lsof
        manpages
        megatools
        metasploit
        mlocate
        mosh
        mpc_cli
        mpd
        mpv
        mtr
        ncmpcpp
        newt
        ngrep
        nix-bundle
        nix-index
        nix-prefetch-git
        nix-prefetch-github
        nix-prefetch-github
        nmap
        nox
        numlockx
        nxBender
        obs-studio
        octave
        openssh
        stable.pandoc
        pass
        pciutils
        perl
        perlPackages.Appcpanminus
        picard
        pinfo
        pngcrush
        posix_man_pages
        powershell
        psmisc
        pup
        pv
        pwgen
        pydf
        python2
        python3
        stable.csvkit
        stable.python3Packages.glances
        qjackctl
        redshift
        ruby
        rustc
        rustfmt
        rustup
        shellcheck
        slack
        socat
        solaar
        sox
        spotify
        sqlite-interactive
        squashfsTools
        sshfs
        stdman
        stdmanpages
        strace
        system-config-printer
        telnet
        texlive.combined.scheme-full
        thunderbird
        time
        tmate
        tor
        tor-browser-bundle
        torsocks
        tree
        unclutter-xfixes
        unrar
        unzip
        up
        usbutils
        stable.virtmanager
        vuze
        wavemon
        wget
        wireshark
        x11_ssh_askpass
        x2goclient
        xar
        xclip
        xcompmgr
        xdg-user-dirs
        xdotool
        xorg.xdpyinfo
        xz
        youtube-dl
        yq
        zfsUnstable
      ];

      sessionVariables = let
        fixup-paths = scripts.fixup-paths;
      in
      rec {
        CCACHE_DIR = "\${HOME}/.ccache";
        CFLAGS = "-march=native -O2 -pipe -ggdb -fstack-protector-strong";
        CXXFLAGS = CFLAGS;
        DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/\${UID}/bus";
        EDITOR = "${config.programs.vim.package}/bin/vim";
        FCFLAGS = CFLAGS;
        FFLAGS = CFLAGS;
        GEM_HOME = "$(${unstable.ruby}/bin/ruby -e 'print Gem.user_dir')";
        GIT_ASKPASS="${unstable.gnome3.seahorse}/libexec/seahorse/ssh-askpass";
        GTK_IM_MODULE = "xim";
        LC_ALL = "en_US.UTF-8";
        LC_CTYPE = "en_US.UTF-8";
        LESSCOLOR = "yes";
        LIBVIRT_DEFAULT_URI = "qemu:///system";
        MPD_HOST = "${config.home.homeDirectory}/.config/mpd/socket";
        NIX_AUTO_RUN = "1";
        PAGER = "less";
        PERL5LIB = "\${HOME}/perl5/lib/perl5";
        PERL_LOCAL_LIB_ROOT = "\${HOME}/perl5";
        PERL_MB_OPT = "--install_base \${HOME}/perl5";
        PERL_MM_OPT = "INSTALL_BASE=\${HOME}/perl5";
        QT_IM_MODULE = "ibus";
        QT3_IM_MODULE = "ibus";
        QT4_IM_MODULE = "ibus";
        QT5_IM_MODULE = "ibus";
        QT_SELECT = "5";
        SSH_ASKPASS="${unstable.gnome3.seahorse}/libexec/seahorse/ssh-askpass";
        SUDO_ASKPASS="${unstable.gnome3.seahorse}/libexec/seahorse/ssh-askpass";
        TEXMFHOME = "\${HOME}/texmf";
        USE_CCACHE = "1";
        XDG_DESKTOP_DIR = "\${HOME}/";
        XDG_DOCUMENTS_DIR = "\${HOME}/src";
        XDG_DOWNLOAD_DIR = "\${HOME}/Downloads";
        XDG_MUSIC_DIR = "\${HOME}/Music";
        XDG_PICTURES_DIR = "\${HOME}/";
        XDG_PUBLICSHARE_DIR = "\${HOME}/";
        XDG_TEMPLATES_DIR = "\${HOME}/";
        XDG_VIDEOS_DIR = "\${HOME}/";
        XMODIFIERS = "@im=ibus";
        _JAVA_OPTIONS = "-Dawt.useSystemAAFontSettings=lcd -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel";

        PYTHONSTARTUP = let
          pythonrc = unstable.writeScript "pythonrc.py" ''
            # This file is sourced by interactive python sessions
            # Partially copied from <http://stackoverflow.com/questions/3613418/what-is-in-your-python-interactive-startup-script>

            from __future__ import division, print_function

            import atexit
            import os
            import readline
            import rlcompleter

            # Tab complete with readline
            readline.parse_and_bind("tab: complete")

            # History
            historyPath = os.path.expanduser("~/.history.py")

            def save_history(historyPath=historyPath):
                import readline
                readline.write_history_file(historyPath)

            if os.path.exists(historyPath):
                readline.read_history_file(historyPath)

            atexit.register(save_history)
            del os, atexit, readline, rlcompleter, save_history, historyPath

            # vim: tabstop=8 expandtab shiftwidth=4 softtabstop=4
          '';
        in
          "${pythonrc}";

        LS_COLORS = let
          solarized = builtins.fetchGit {
            url = "https://github.com/seebi/dircolors-solarized.git";
            ref = "master";
          };

          colorfile = "${solarized}/dircolors.ansi-dark";

          default_colors = unstable.writeScript "defcolors.sh" ''
            #!/usr/bin/env bash

            unset LS_COLORS
            export TERM=xterm-kitty
            eval "$(${unstable.coreutils}/bin/dircolors "${colorfile}")" 2>/dev/null
            echo "$LS_COLORS"
          '';
        in
          "$(${default_colors}):*.green=04;32";

        PATH = let
          rawpath = builtins.concatStringsSep ":" [
            # Local scripts.
            "\${HOME}/.local/bin"

            "\${HOME}/.cargo/bin"
            "\${HOME}/${programs.go.goBin}"
            "\${HOME}/perl5/bin"
            "${GEM_HOME}/bin"

            # Nix/NixOS paths.
            "/run/wrappers/bin"
            "\${HOME}/.nix-profile/bin"
            "/run/current-system/sw/bin"
            "/nix/var/nix/profiles/default/bin"

            # General system paths.
            "/usr/local/sbin"
            "/usr/local/bin"
            "/usr/sbin"
            "/usr/bin"
            "/sbin"
            "/bin"

            # Original path.
            "\${PATH}"
          ];
        in
          "$(${fixup-paths} \"${rawpath}\")";

        GEM_PATH = let
          rawpath = builtins.concatStringsSep ":" [
            "$(${unstable.ruby}/bin/gem env path)"
            "\${GEM_HOME}"
          ];
        in
          "$(${fixup-paths} \"${rawpath}\")";

        MANPATH = let
          rawpath = builtins.concatStringsSep ":" [
            # Local scripts.
            "\${HOME}/.local/share/man"

            # Nix/NixOS paths.
            "\${HOME}/.nix-profile/share/man"
            "/run/current-system/sw/share/man"
            "/nix/var/nix/profiles/default/share/man"

            # General system paths.
            "/usr/local/share/man"
            "/usr/share/man"

            # Original path.
            "\$(manpath -q)"
          ];
        in
          "$(${fixup-paths} \"${rawpath}\")";
      };

      stateVersion = "19.03";
    };

    manual = {
      html = {
        enable = true;
      };

      manpages = {
        enable = true;
      };
    };

    news = {
      display = "notify";
    };

    programs = {
      autorandr = {
        enable = true;

        profiles = let

          nightmare-display = "00ffffffffffff0006af9d1200000000001a0104a526157802d295a356529d270b50540000000101010101010101010101010101010132698078703814400a0a33007dd61000001832698078703860440a0a33007dd610000018000000fe0041554f0a202020202020202020000000fe004231373348414e30312e32200a0058";
          work-displayport = "00ffffffffffff0010acb8a0554e3531251c0104a53420783a0495a9554d9d26105054a54b00714f8180a940d1c0d100010101010101283c80a070b023403020360006442100001e000000ff00434656394e38393931354e550a000000fc0044454c4c2055323431350a2020000000fd00313d1e5311000a202020202020010302031cf14f9005040302071601141f12132021222309070783010000023a801871382d40582c450006442100001e011d8018711c1620582c250006442100009e011d007251d01e206e28550006442100001e8c0ad08a20e02d10103e96000644210000180000000000000000000000000000000000000000000000000000000c";
          aurora-display = "00ffffffffffff000daed31400000000161a0104951f117802ee95a3544c99260f505400000001010101010101010101010101010101b43b804a713834403020350035ad1000001ab43b804a713834403020350035ad1000001a000000fe003438444757803134304843450a00000000000041019e001000000a010a2020005a";

        in {
          "nightmare-work-docked" = {
            fingerprint = {
              DP-0 = nightmare-display;
              DP-1 = work-displayport;
            };

            config = {
              DP-0 = {
                enable = true;
                mode = "1920x1080";
                position = "1920x120";
                primary = true;
                rate = "120.01";
              };
              DP-1 = {
                enable = true;
                mode = "1920x1200";
                position = "0x0";
                rate = "59.95";
                primary = false;
              };
            };
          };

          "nightmare-undocked" = {
            fingerprint = {
              DP-0 = nightmare-display;
            };

            config = {
              DP-0 = {
                enable = true;
                mode = "1920x1080";
                position = "0x0";
                primary = true;
                rate = "120.01";
              };
            };
          };

          "aurora-work-docked" = {
            fingerprint = {
              eDP1 = aurora-display;
              DP1-2 = work-displayport;
            };

            config = {
              eDP1 = {
                enable = true;
                mode = "1920x1080";
                position = "1920x120";
                primary = true;
                rate = "120.01";
              };
              DP1-2 = {
                enable = true;
                mode = "1920x1200";
                position = "0x0";
                rate = "59.95";
                primary = false;
              };
            };
          };

          "aurora-undocked" = {
            fingerprint = {
              eDP1 = aurora-display;
            };

            config = {
              eDP1 = {
                enable = true;
                mode = "1920x1080";
                position = "0x0";
                primary = true;
                rate = "120.01";
              };
            };
          };
        };
      };

      browserpass = {
        browsers = [
          "chromium"
        ];
        enable = true;
      };

      chromium = {
        enable = true;

        extensions = [
          "bigefpfhnfcobdlfbedofhhaibnlghod" # MEGA
          "cfhdojbkjhnklbpkdaibdccddilifddb" # Adblock Plus
          "clngdbkpkpeebahjckkjfobafhncgmne" # Stylus
          "dbepggeogbaibhgnhhndojpepiihcmeb" # Vimium
          "elcalhmjjbiopoblmomhgelkfafpgogb" # Retain me not
          "gcbommkclmclpchllfjekcdonpmejbdp" # HTTPS Everywhere
          "hompjdfbfmmmgflfjdlnkohcplmboaeo" # Allow Right-Click
          "iggpfpnahkgpnindfkdncknoldgnccdg" # YouTube Looper
          "kbmfpngjjgdllneeigpgjifpgocmfgmb" # Reddit Enhancement Suite
          "naepdomgkenhinolocfifgehidddafch" # browserpass-ce
          "ohnjgmpcibpbafdlkimncjhflgedgpam" # 4chan X
        ];

        package = master.chromium;
      };

      command-not-found = {
        enable = true;
      };

      direnv = {
        enable = true;
      };

      fzf = {
        enable = true;
      };

      git = {
        aliases = {
          logg = "log --date-order --graph --stat";
          loggs = "log --date-order --graph --stat --show-signature";
          logga = "log --date-order --all --graph --stat";
          loggas = "log --date-order --all --graph --stat --show-signature";
          serve = "daemon --verbose --export-all --base-path=.git --reuseaddr --strict-paths .git/";
          sign-rebase = "\"!GIT_SEQUENCE_EDITOR='sed -i -re s/^pick/e/' sh -c 'git rebase -i \$1 && while git rebase --continue; do git commit --amend --sign --no-edit; done' -\"";
          signoff-rebase = "\"!GIT_SEQUENCE_EDITOR='sed -i -re s/^pick/e/' sh -c 'git rebase -i \$1 && while git rebase --continue; do git commit --amend --signoff --no-edit; done' -\"";
        };

        enable = true;

        ignores = [
          ".*.sw[op]"
          ".ctags"
          ".ctags.temp"
          ".ctags.lock"
          "tags"
          "tags.temp"
          "tags.lock"
        ];

        includes = [
          {
            path = "~/.config/git/config.local";
          }
        ];

        package = unstable.gitAndTools.gitFull;

        signing = {
          key = hostinfo.gpgKey;
          signByDefault = true;
        };

        userEmail = "i.am.the.memory@gmail.com";

        userName = "Alexandria Corkwell";

        extraConfig = {
          color = {
            ui = true;
          };

          core = {
            editor = "vim";
            abbrev = 12;
          };

          credential = {
            helper = "libsecret";
          };

          fetch = {
            prune = true;
          };

          merge = {
            ff = false;
            tool = "vimdiff2";
          };

          pull = {
            ff = "only";
          };

          push = {
            default = "simple";
            gpgsign = "if-asked";
          };

          submodule = {
            recurse = true;
          };

          "filter \"lfs\"" = {
            clean = "git-lfs clean -- %f";
            smudge = "git-lfs smudge -- %f";
            required = true;
            process = "git-lfs filter-process";
          };
        };
      };

      go = {
        enable = true;

        goBin = ".local/go/bin";

        goPath = ".local/go";
      };

      home-manager = {
        enable = true;
        path = https://github.com/rycee/home-manager/archive/master.tar.gz;
      };

      htop = {
        enable = true;
        accountGuestInCpuMeter = true;
        colorScheme = 6;
        cpuCountFromZero = true;
        delay = 10;
        detailedCpuTime = true;
        fields = [
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
        headerMargin = false;
        hideKernelThreads = true;
        hideThreads = true;
        hideUserlandThreads = true;
        highlightBaseName = true;

        meters = {
          left = [
            "AllCPUs2"
            "CPU"
            "Memory"
            "Swap"
            { kind = "Battery"; mode = 1; }
          ];

          right = [
            "Hostname"
            "Tasks"
            "LoadAverage"
            "Uptime"
            "Clock"
          ];
        };

        shadowOtherUsers = true;

        showProgramPath = true;
        showThreadNames = true;
        treeView = true;
      };

      info = {
        enable = true;
      };

      lesspipe = {
        enable = true;
      };

      man = {
        enable = true;
      };

      ssh = {
        enable = true;

        compression = true;

        controlMaster = "auto";

        controlPath = "~/.ssh/master-%r@%h:%p";

        controlPersist = "10m";

        hashKnownHosts = true;

        serverAliveInterval = 30;
      };

      texlive = {
        #enable = true;
      };

      tmux = {
        enable = true;

        plugins = [
          unstable.tmuxPlugins.sensible
          {
            plugin = unstable.tmuxPlugins.resurrect;
            extraConfig = ''
              set -g @resurrect-strategy-vim 'session'
            '';
          }
          {
            plugin = unstable.tmuxPlugins.continuum;
            extraConfig = ''
              set -g @continuum-restore 'on'
            '';
          }
        ];

        extraConfig = ''
          # Use 256 colors
          set -g default-terminal "screen-256color"

          # Use a 10 000 line scrollback buffer
          set -g history-limit 10000

          # Use r to reload the tmux config
          bind r source-file ~/.tmux.conf

          # Keep tmux running when all clients exit
          set -g exit-unattached off

          # Vi-like keys
          set -g status-keys vi
          set -g mode-keys vi

          # Use a faster bind-key repeat timeout
          set -g repeat-time 200

          # Use vi-like window navigation
          unbind-key Down
          unbind-key j
          bind-key -r j select-pane -D

          unbind-key Up
          unbind-key k
          bind-key -r k select-pane -U

          unbind-key Left
          unbind-key h
          bind-key -r h select-pane -L

          unbind-key Right
          unbind-key l
          bind-key -r l select-pane -R

          # Use vi-like keys for resizing
          unbind-key C-Down
          unbind-key C-j
          bind-key -r C-j resize-pane -D
          unbind-key M-Down

          unbind-key C-Up
          unbind-key C-k
          bind-key -r C-k resize-pane -U
          unbind-key M-Up

          unbind-key C-Left
          unbind-key C-h
          bind-key -r C-h resize-pane -L
          unbind-key M-Left

          unbind-key C-Right
          unbind-key C-l
          bind-key -r C-l resize-pane -R
          unbind-key M-Right

          # Only automatically update a few environment variables on session creation
          set -g update-environment "SSH_ASKPASS WINDOWID"

          # Right status
          set -g status-right "#{=82:pane_title} %H:%M %Y-%b-%d"
          set -g status-right-length 100

          # Use C-a instead of C-b
          set-option -g prefix C-a
          bind-key C-a last-window
          bind-key a send-prefix

          # Don't overwrite the names.
          set-option -g allow-rename off

          # Re-attach clients to other sessions when all of the windows are closed.
          set -g detach-on-destroy off
        '';
      };
    };

    services = {
      blueman-applet = {
        enable = true;
      };

      compton = {
        enable = true;
        package = unstable.compton;

        activeOpacity = "1.0";
        blur = false;
        fade = false;
        inactiveOpacity = "1.0";
        menuOpacity = "1.0";
        noDNDShadow = true;
        noDockShadow = true;
        shadow = false;

        extraOptions = ''
          paint-on-overlay = true;
          mark-ovredir-focused = true;
        '';
      };

      dunst = {
        enable = true;

        iconTheme = {
          name = "Adwaita";
          package = unstable.gnome3.adwaita-icon-theme;
          size = "16x16";
        };

        settings = {
          global = {
            alignment = "left";
            always_run_script = "true";
            browser = "${config.programs.chromium.package}/bin/chromium";
            class = "Dunst";
            corner_radius = 0;
            dmenu = "dmenu -p dunst:";
            ellipsize = "middle";
            follow = "mouse";
            font = "Literation Mono Nerd Font 8";
            force_xinerama = false;
            format = "<i>%a</i>: <b>%s</b>\\n%b\\n%p";
            frame_color = "#aaaaaa";
            frame_width = 3;
            geometry = "300x5-30+20";
            hide_duplicate_count = "false";
            history_length = 20;
            horizontal_padding = 8;
            icon_position = "left";
            idle_threshold = 120;
            ignore_newline = "no";
            indicate_hidden = "yes";
            line_height = 0;
            markup = "full";
            max_icon_size = 16;
            notification_height = 0;
            padding = 8;
            separator_color = "frame";
            separator_height = 2;
            show_age_threshold = 60;
            show_indicators = "yes";
            shrink = "no";
            sort = "yes";
            stack_duplicates = "true";
            startup_notification = "true";
            sticky_history = "yes";
            title = "Dunst";
            transparency = 30;
            verbosity = "mesg";
            word_wrap = "yes";
          };

          experimental = {
            per_monitor_dpi = "false";
          };

          shortcuts = {
            close = "ctrl+shift+grave";
            #close_all = "ctrl+shift+space";
            history = "ctrl+grave";
            #context = "ctrl+shift+period";
          };

          urgency_low = {
            background = "#222222";
            foreground = "#888888";
            timeout = 10;
          };

          urgency_normal = {
            background = "#285577";
            foreground = "#ffffff";
            timeout = 10;
          };

          urgency_critical = {
            background = "#900000";
            foreground = "#ffffff";
            frame_color = "#ff0000";
            timeout = 0;
          };
        };
      };

      flameshot = {
        enable = true;
      };

      gnome-keyring = {
        enable = true;

        components = [
          "pkcs11"
          "secrets"
          "ssh"
        ];
      };

      gpg-agent = {
        defaultCacheTtl = 3600;
        enable = true;
        grabKeyboardAndMouse = true;
        maxCacheTtl = 21600;
      };

      kbfs = {
        enable = true;
      };

      kdeconnect = {
        enable = true;
        indicator = true;
      };

      keybase = {
        enable = true;
      };

      network-manager-applet = {
        enable = true;
      };

      redshift = {
        enable = true;
        package = unstable.redshift;

        brightness = {
          day = "1.0";
          night = "0.25";
        };

        provider = "geoclue2";

        temperature = {
          day = 5500;
          night = 3700;
        };

        tray = true;
      };

      unclutter = {
        enable = true;
        package = unstable.unclutter-xfixes;

        extraOptions = [
        ];

        threshold = 1;

        timeout = 1;
      };
    };

    xdg = {
      enable = true;

      cacheHome = "${config.home.homeDirectory}/.cache";
      configHome = "${config.home.homeDirectory}/.config";
      dataHome = "${config.home.homeDirectory}/.local/share";
    };

    xresources = {
      properties = {
        "Xft.dpi" = 96;
      };
    };

    xsession = {
      enable = true;

      initExtra = ''
        # Dim after 10 minutes, lock 10 minutes later.
        ${unstable.xorg.xset}/bin/xset s 600 1200

        # Turn on numlock.
        ${unstable.numlockx}/bin/numlockx on

        # Set middle-button emulation.
        for input in $(${unstable.xorg.xinput}/bin/xinput --list | ${unstable.gnugrep}/bin/grep 'Logitech' | ${unstable.gnused}/bin/sed -r 's/.*\tid=([0-9]+)[^0-9].*$/\1/')
        do
          ${unstable.xorg.xinput}/bin/xinput --set-prop "$input" "libinput Middle Emulation Enabled" 1
        done

        # Turn off touchpad.
        ${unstable.xorg.xinput}/bin/xinput disable 'pointer:SynPS/2 Synaptics TouchPad'
        ${unstable.xorg.xinput}/bin/xinput disable 'pointer:DELL081C:00 044E:121F Touchpad'
        ${unstable.xorg.xinput}/bin/xinput disable 'pointer:DELL081C:00 044E:121F Mouse'

        # Disable Yubikey by default.
        ${unstable.xorg.xinput}/bin/xinput disable 'Yubico Yubikey 4 OTP+U2F+CCID'

        # Run autorandr.
        ${unstable.autorandr}/bin/autorandr -c
      '';

      profileExtra = ''
      '';

      windowManager = {
        i3 = rec {
          enable = true;
          package = unstable.i3;

          config = rec {
            assigns = {
              "1:disc" = [
                { class = "^discord$"; }
              ];

              "2:sys" = [
                { class = "^deluge$"; }
              ];

              "3:mail" = [
                { class = "^Thunderbird$"; }
                { class = "^Daily$"; title = "- Thunderbird Daily$"; }
              ];

              "4:ffdoc" = [
              ];

              "5:ffxiv" = [
                { instance = "^ffxiv(|launcher|_dx11|boot)\\.exe$"; }
              ];

              "6" = [
              ];

              "7" = [
              ];

              "8" = [
              ];

              "9:misc" = [
              ];

              "10:steam" = [
                { class = "^Steam$"; }
              ];

              "scratchpad" = [
                { class = "^Spotify$"; }
                { class = "^Keybase$"; }
              ];
            };

            bars = [
              {
                inherit fonts;

                colors = {
                  background = "#000000";
                  statusline = "#ffffff";
                  separator = "#666666";

                  activeWorkspace = {
                    background = "#68627e";
                    border = "#4f4865";
                    text = "#ffffff";
                  };

                  focusedWorkspace = {
                    background = "#7e3fa0";
                    border = "#6c2593";
                    text = "#ffffff";
                  };

                  inactiveWorkspace = {
                    background = "#443344";
                    border = "#332233";
                    text = "#998899";
                  };

                  urgentWorkspace = {
                    background = "#c0458b";
                    border = "#b02574";
                    text = "#ffffff";
                  };

                  bindingMode = {
                    background = "#c0458b";
                    border = "#b02574";
                    text = "#ffffff";
                  };
                };

                statusCommand = "${unstable.i3pystatus}/bin/i3pystatus -c ${scripts.i3pystatus-top}";

                id = "bar-top";
                position = "top";

                trayOutput = "none";

                workspaceButtons = false;
              }
              {
                inherit fonts;

                colors = {
                  background = "#000000";
                  statusline = "#ffffff";
                  separator = "#666666";

                  activeWorkspace = {
                    background = "#68627e";
                    border = "#4f4865";
                    text = "#ffffff";
                  };

                  focusedWorkspace = {
                    background = "#7e3fa0";
                    border = "#6c2593";
                    text = "#ffffff";
                  };

                  inactiveWorkspace = {
                    background = "#443344";
                    border = "#332233";
                    text = "#998899";
                  };

                  urgentWorkspace = {
                    background = "#c0458b";
                    border = "#b02574";
                    text = "#ffffff";
                  };

                  bindingMode = {
                    background = "#c0458b";
                    border = "#b02574";
                    text = "#ffffff";
                  };
                };

                statusCommand = "${unstable.i3pystatus}/bin/i3pystatus -c ${scripts.i3pystatus-bottom}";

                id = "bar-bottom";
                position = "bottom";

                trayOutput = "primary";

                workspaceButtons = true;
                workspaceNumbers = true;
              }
            ];

            # <http://paletton.com/#uid=54H0u1kperCfyB2k-u6snmHvThUkperCfyB2k-u6snmHvThUkaxit5ash85mVbXc9jwbs>

            colors = {
              background = "#ffffff";

              focused = {
                border = "#7e3fa0";
                background = "#6c2593";
                text = "#ffffff";
                indicator = "#9c65ba";
                childBorder = "#6c2593";
              };

              focusedInactive = {
                border = "#68627e";
                background = "#4f4865";
                text = "#ffffff";
                indicator = "#8a859b";
                childBorder = "#4f4865";
              };

              placeholder = {
                border = "#000000";
                background = "#0c0c0c";
                text = "#ffffff";
                indicator = "#000000";
                childBorder = "#0c0c0c";
              };

              unfocused = {
                border = "#443344";
                background = "#332233";
                text = "#998899";
                indicator = "#3e2d3e";
                childBorder = "#332233";
              };

              urgent = {
                border = "#c0458b";
                background = "#b02574";
                text = "#ffffff";
                indicator = "#d66ea9";
                childBorder = "#b02574";
              };
            };

            floating = {
              criteria = [
                { class = "^Spotify$"; }
                { class = "^Keybase$"; }
              ];

              titlebar = true;
            };

            focus = {
              followMouse = true;
              mouseWarping = false;
            };

            fonts = [
              "Literation Mono Nerd Font 8"
            ];

            startup = [
              { command = "~/.local/bin/discord.sh"; }
              { command = "${master.steam}/bin/steam"; }
              { command = "${unstable.thunderbird}/bin/thunderbird"; }
              { command = "${unstable.spotify}/bin/spotify"; }
              { command = "${unstable.system-config-printer}/bin/system-config-printer-applet"; }
              { command = "${ibus-full}/bin/ibus-daemon -drx"; }
              { command = "${unstable.bitcoin}/bin/bitcoin-qt"; }
            ];

            workspaceLayout = "tabbed";

            window = {
              border = 2;

              commands = [
                { command = "border none"; criteria = { instance = "^ffxiv(|_dx11)\\.exe$"; }; }
              ];
            };
          };

          extraConfig = ''
            default_border pixel 2
            default_floating_border pixel 2
          '';
        };
      };

      pointerCursor = {
        package = unstable.gnome3.adwaita-icon-theme;
        name = "Adwaita";
        size = 16;
      };
    };
  }
