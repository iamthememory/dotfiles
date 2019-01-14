{ config, lib, options, ... }:
let
  inherit (import ./channels.nix) stable unstable jellyfish staging;

  scripts = import ./scripts { inherit config; };

  speedswapper = scripts.speedswapper;
in
  rec {
    imports = [
      ./games
      ./gui
      ./zsh
    ];

    home = {
      file = {
        # FIXME.
      };

      extraOutputsToInstall = [
        "bin"
        "devdoc"
        "doc"
        "info"
        "man"
      ];

      keyboard = {
        layout = "us";

        options = [
          "compose:lwin"
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
        autorandr
        avahi
        bashInteractive
        bc
        binutils
        blueman
        bumpversion
        bzip2
        config.programs.chromium.package
        chrony
        cloc
        cookiecutter
        coreutils
        ctags
        curl
        ddrescue
        diceware
        direnv
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
        gnugrep
        gnupg
        gnuplot
        gnutar
        gptfdisk
        graphviz
        gzip
        host
        htop
        httpie
        i3
        ibus
        ibus-engines.anthy
        ibus-engines.table
        ibus-engines.table-others
        imagemagick
        inkscape
        iotop
        jq
        kbfs
        kdeconnect
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
        man
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
        octave
        openssh
        stable.pandoc
        pass
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
        python3Packages.csvkit
        stable.python3Packages.glances
        redshift
        ruby
        shellcheck
        skypeforlinux
        slack
        socat
        solaar
        sox
        spotify
        sqlite-interactive
        squashfsTools
        sshfs
        strace
        system-config-printer
        telnet
        texlive.combined.scheme-full
        thunderbird
        time
        tmate
        tmux
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
        wget
        wireshark
        x11_ssh_askpass
        xar
        xclip
        xcompmgr
        xdg-user-dirs
        xdotool
        xorg.xdpyinfo
        xz
        youtube-dl
        zfs
      ];

      sessionVariables = let
        fixup-paths = scripts.fixup-paths;
      in
      rec {
        CCACHE_DIR = "\${HOME}/.ccache";
        CFLAGS = "-march=native -O2 -pipe -ggdb -fstack-protector-strong";
        CXXFLAGS = CFLAGS;
        DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/\${UID}/bus";
        EDITOR = "\${HOME}/.nix-profile/bin/vim";
        FCFLAGS = CFLAGS;
        FFLAGS = CFLAGS;
        GEM_HOME = "$(${unstable.ruby}/bin/ruby -e 'print Gem.user_dir')";
        GIT_ASKPASS="${unstable.gnome3.seahorse}/libexec/seahorse/ssh-askpass";
        GTK_IM_MODULE = "ibus";
        LANG = "en_US.UTF-8";
        LC_ALL = "en_US.UTF-8";
        LC_CTYPE = "en_US.UTF-8";
        LESSCOLOR = "yes";
        LIBVIRT_DEFAULT_URI = "qemu:///system";
        MPD_HOST = "${XDG_CONFIG_HOME}/mpd/socket";
        NIX_AUTO_RUN = "1";
        PAGER = "less";
        PERL5LIB = "\${HOME}/perl5/lib/perl5";
        PERL_LOCAL_LIB_ROOT = "\${HOME}/perl5";
        PERL_MB_OPT = "--install_base \${HOME}/perl5";
        PERL_MM_OPT = "INSTALL_BASE=\${HOME}/perl5";
        QT_IM_MODULE = "ibus";
        QT_SELECT = "5";
        SSH_ASKPASS="${unstable.gnome3.seahorse}/libexec/seahorse/ssh-askpass";
        SUDO_ASKPASS="${unstable.gnome3.seahorse}/libexec/seahorse/ssh-askpass";
        TERM = "screen-256color";
        TEXMFHOME = "\${HOME}/texmf";
        USE_CCACHE = "1";
        XDG_CACHE_HOME = "\${HOME}/.cache";
        XDG_CONFIG_HOME = "\${HOME}/.config";
        XDG_DATA_HOME = "\${HOME}/.local/share";
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

        PYTHONSTARTUP = unstable.writeScript "pythonrc.py" ''
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

        LS_COLORS = let
          solarized = builtins.fetchGit {
            url = "https://github.com/seebi/dircolors-solarized.git";
            ref = "master";
          };

          colorfile = "${solarized}/dircolors.ansi-dark";

          default_colors = unstable.writeScript "defcolors.sh" ''
            #!/usr/bin/env bash

            unset LS_COLORS
            export TERM=screen-256color
            eval "$(${unstable.coreutils}/bin/dircolors "${colorfile}")" 2>/dev/null
            echo "$LS_COLORS"
          '';
        in
          "$(${default_colors}):*.green=04;32";

        PATH = let
          rawpath = builtins.concatStringsSep ":" [
            # Local scripts.
            "\${HOME}/.local/bin"

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

        INFOPATH = let
          rawpath = builtins.concatStringsSep ":" [
            # Local scripts.
            "\${HOME}/.local/share/info"

            # Nix/NixOS paths.
            "\${HOME}/.nix-profile/share/info"
            "/run/current-system/sw/share/info"
            "/nix/var/nix/profiles/default/share/info"

            # General system paths.
            "/usr/local/share/info"
            "/usr/share/info"

            # Original path.
            "\${INFOPATH}"
          ];
        in
          "$(${fixup-paths} \"${rawpath}\")";
      };

      stateVersion = "18.09";
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
                position = "0x120";
                primary = true;
                rate = "120.01";
              };
              DP-1 = {
                enable = true;
                mode = "1920x1200";
                position = "1920x0";
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

        package = unstable.chromium;
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
        ];

        includes = [
          {
            path = "~/.config/git/config.local";
          }
        ];

        package = unstable.gitAndTools.gitFull;

        signing = {
          key = "0xD226B54765D868B7";
          signByDefault = true;
        };

        userEmail = "i.am.the.memory@gmail.com";

        userName = "Alexandria Corkwell";

        extraConfig = ''
          [color]
            ui = true

          [core]
            editor = vim
            abbrev = 12

          [credential]
            helper = libsecret

          [fetch]
            prune = true

          [merge]
            ff = false
            tool = vimdiff2

          [pull]
            ff = only

          [push]
            default = simple
            gpgsign = if-asked

          [submodule]
            recurse = true

          [filter "lfs"]
            clean = git-lfs clean -- %f
            smudge = git-lfs smudge -- %f
            required = true
            process = git-lfs filter-process

        '';
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

      vim = {
        enable = true;

        plugins = [
          "editorconfig-vim"
          "haskell-vim"
          "nerdtree"
          "nerdtree-git-plugin"
          "tagbar"
          "vim-airline"
          "vim-airline-themes"
          "vim-colors-solarized"
          "vim-devicons"
          "vim-dispatch"
          "vim-eunuch"
          "vim-fugitive"
          "vim-gitgutter"
          "vim-obsession"
          "vim-polyglot"
          "vim-sensible"
          "vundle"
        ];

        extraConfig = ''
          " Don't use compatibility mode
          set nocompatible
          set updatetime=100
          let g:airline#extensions#tabline#enabled = 1
          let g:airline_powerline_fonts = 1

          " Recover (diff swapfiles when recovering buffers).
          "Plugin 'chrisbra/Recover.vim'
          let g:haskell_indent_if = 4
          let g:haskell_indent_case = 4
          let g:haskell_indent_let = 4
          let g:haskell_indent_where = 2
          let g:haskell_indent_do = 4
          let g:haskell_indent_in = 4
          let g:haskell_indent_guard = 2
          let g:cabal_indent_section = 4

          " vim-rst-tables (reformat reStructuredText tables).
          " Doesn't really work with Python 3.
          "Plugin 'ossobv/vim-rst-tables-py3'

          " VST (reStructuredText).
          "Plugin 'VST'

          " vim-nerdtree-syntax-highlight (extra colors for nerdtree).
          "Plugin 'tiagofumo/vim-nerdtree-syntax-highlight'
          set encoding=UTF-8

          colorscheme solarized

          " Look and feel.

          " If I'm in a terminal, assume the background is dark.
          if !has('gui_running')
            set background=dark
          endif

          " Mark at 80 characters
          set colorcolumn=80

          " Show folds on the left.
          set foldcolumn=2
          set foldlevel=2

          " Show line numbers by default.
          set number

          " Behavior.

          " Case insensitive search if all lowercase.
          set ignorecase
          set smartcase

          " Better file tab completion.
          set wildmode=longest,list,full

          " Formatting options.
          set formatoptions+=tcqjn

          " Keep indents on linebreak.
          set breakindent

          " Show tabs, spaces, etc.
          set list

          " Show highlighting on searchs.
          set hlsearch


          " Try to template from a skeleton.
          autocmd BufNewFile *.* silent! execute '0r $HOME/.vim/templates/skeleton.'.expand("<afile>:e")

          " Default printer options
          set printoptions=paper:letter,duplex:long,top:7pc,bottom:5pc,left:5pc,right:5pc,header:2,number:y,syntax:y

          " Add :Man to open manpages
          runtime! ftplugin/man.vim

          " Save current buffer and make in the background.
          noremap <Leader>m :w<CR>:Make!<CR>

          " Use Doxygen in C/C++ files.
          au BufRead,BufNewFile *.c set filetype=c.doxygen
          au BufRead,BufNewFile *.cpp set filetype=cpp.doxygen
          au BufRead,BufNewFile *.h set filetype=cpp.doxygen
          au BufRead,BufNewFile *.h.in set filetype=cpp.doxygen

          " Assume LaTeX format for TeX files
          let g:tex_flavor='latex'
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
            close = "ctrl+space";
            close_all = "ctrl+shift+space";
            history = "ctrl+grave";
            context = "ctrl+shift+period";
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

        # Activate Compose key.
        ${unstable.xorg.setxkbmap}/bin/setxkbmap -model evdev -layout us -option compose:lwin

        # Swap caps lock and escape.
        ${unstable.xorg.xmodmap}/bin/xmodmap ${speedswapper}

        # Disable Yubikey by default.
        ${unstable.xorg.xinput}/bin/xinput disable 'Yubico Yubikey 4 OTP+U2F+CCID'
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

              "8:slack" = [
                { class = "^Slack$"; }
              ];

              "9:misc" = [
              ];

              "10:steam" = [
                { class = "^Steam$"; }
              ];

              "scratchpad" = [
                { class = "^Spotify$"; }
                { class = "^Skype$"; }
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

                statusCommand = "${unstable.i3pystatus}/bin/i3pystatus -c ~/.config/i3pystatus/top.py";

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

                statusCommand = "${unstable.i3pystatus}/bin/i3pystatus -c ~/.config/i3pystatus/bottom.py";

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
                { class = "^Skype$"; }
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
              { command = "${unstable.steam}/bin/steam"; }
              { command = "${unstable.thunderbird}/bin/thunderbird"; }
              { command = "${unstable.spotify}/bin/spotify"; }
              { command = "${unstable.slack}/bin/slack"; }
              { command = "${unstable.skypeforlinux}/bin/skypeforlinux"; }
              { command = "${unstable.system-config-printer}/bin/system-config-printer-applet"; }
              { command = "${unstable.ibus}/bin/ibus-daemon -drx"; }
            ];

            workspaceLayout = "tabbed";

            window = {
              border = 2;

              commands = [
                { command = "border none"; criteria = { instance = "^ffxiv\\.exe$"; }; }
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