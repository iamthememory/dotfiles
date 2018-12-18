{ pkgs, ... }:
let
  import-channel = c: (
    import (
      builtins.fetchTarball
      "https://nixos.org/channels/nixos-${c}/nixexprs.tar.xz"
    )
  ) {};

  import-branch = b: (
    import (
      builtins.fetchGit {
        url = "https://github.com/nixos/nixpkgs.git";
        ref = b;
      }
    )
  ) {};

  aardvark    = import-channel "13.10";
  baboon      = import-channel "14.04";
  caterpillar = import-channel "14.12";
  dingo       = import-channel "15.09";
  emu         = import-channel "16.03";
  flounder    = import-channel "16.09";
  gorilla     = import-channel "17.03";
  hummingbird = import-channel "17.09";
  impala      = import-channel "18.03";
  jellyfish   = import-channel "18.09";

  unstable    = import-channel "unstable";

  staging     = import-branch  "staging";

  speedswapper = unstable.writeText "speedswapper" ''
    ! Swap caps lock and escape
    remove Lock = Caps_Lock
    keysym Escape = Caps_Lock
    keysym Caps_Lock = Escape
    add Lock = Caps_Lock
  '';
in
  rec {
    fonts = {
      fontconfig = {
        enableProfileFonts = true;
      };
    };

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
        base = "en_US";
      };

      packages = with unstable; [
        R
        acct
        ack
        ag
        agrep
        aircrack-ng
        appimage-run
        #dwarf-fortress-packages.dwarf-fortress-full
        #libreoffice-fresh
        aria2
        autorandr
        avahi
        bash-completion
        bashInteractive
        bc
        binutils
        blueman
        bumpversion
        bzip2
        cabextract
        cataclysm-dda-git
        chromium
        chrony
        cloc
        cookiecutter
        corefonts
        coreutils
        ctags
        curl
        ddrescue
        dejavu_fonts
        diceware
        direnv
        discord
        dmenu
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
        font-droid
        ftb
        gimp
        git-lfs
        gitAndTools.gitflow
        gitFull
        gksu
        gnome3.adwaita-icon-theme
        gnome3.eog
        gnome3.gnome-disk-utility
        gnome3.nautilus
        gnome3.networkmanagerapplet
        gnome3.seahorse
        gnome3.zenity
        gnupg
        gnuplot
        gnutar
        gptfdisk
        graphviz
        gzip
        host
        htop
        i3
        i3lock
        ibus
        ibus-engines.anthy
        ibus-engines.table
        ibus-engines.table-others
        imagemagick
        inkscape
        innoextract
        iotop
        ipafont
        jq
        jre
        kbfs
        kdeconnect
        keybase-gui
        league-of-moveable-type
        liberation_ttf
        libisoburn
        libnotify
        lightdm
        lightdm_gtk_greeter
        links
        linuxPackages.systemtap
        lm_sensors
        lsof
        man
        manpages
        mcomix
        megatools
        metasploit
        mlocate
        mosh
        mpc_cli
        mpd
        mpv
        mtr
        ncmpcpp
        nerdfonts
        nethack
        ngrep
        nix-bundle
        nix-index
        nix-prefetch-git
        nix-prefetch-github
        nix-prefetch-github
        nmap
        noto-fonts
        noto-fonts-cjk
        noto-fonts-emoji
        noto-fonts-extra
        nox
        numlockx
        nxBender
        octave
        openrct2
        openssh
        pamixer
        pandoc
        pass
        pavucontrol
        perl
        perlPackages.Appcpanminus
        picard
        pinfo
        playerctl
        playonlinux
        pngcrush
        posix_man_pages
        powerline-fonts
        powershell
        psmisc
        pv
        pwgen
        pydf
        python2
        python3
        python36Packages.csvkit
        python36Packages.glances
        redshift
        ruby
        scanmem
        scrot
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
        sshfs
        st
        steam
        steam-run
        strace
        system-config-printer
        telnet
        texlive.combined.scheme-full
        thunderbird
        time
        tinyfugue
        tmate
        tmux
        tor
        tor-browser-bundle
        torsocks
        tree
        ttyrec
        unclutter-xfixes
        unrar
        unzip
        up
        usbutils
        usbutils
        virtmanager
        wget
        wineStaging
        winetricks
        wireshark
        x11_ssh_askpass
        xar
        xclip
        xcompmgr
        xdg-user-dirs
        xdotool
        xorg.xdpyinfo
        xorg.xkill
        xorg.xmodmap
        xss-lock
        xz
        youtube-dl
        zfs
        zsh
        zsh-completions
      ];

      sessionVariables = rec {
        CCACHE_DIR = "\${HOME}/.ccache";
        CFLAGS = "-march=native -O2 -pipe -ggdb -fstack-protector-strong";
        CXXFLAGS = CFLAGS;
        DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/\${UID}/bus";
        EDITOR = "\${HOME}/.nix-profile/bin/vim";
        FCFLAGS = CFLAGS;
        FFLAGS = CFLAGS;
        GEM_HOME = "$(${unstable.ruby}/bin/ruby -e 'print Gem.user_dir')";
        GIT_ASKPASS="${unstable.gnome3.seahorse}/lib/seahorse/seahorse-ssh-askpass";
        GTK_IM_MODULE = "ibus";
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
        SSH_ASKPASS="${unstable.gnome3.seahorse}/lib/seahorse/seahorse-ssh-askpass";
        SUDO_ASKPASS="${unstable.gnome3.seahorse}/lib/seahorse/seahorse-ssh-askpass";
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
          "$(~/.local/bin/fixup-path.sh \"${rawpath}\")";

        GEM_PATH = let
          rawpath = builtins.concatStringsSep ":" [
            "$(${unstable.ruby}/bin/gem env path)"
            "\${GEM_HOME}"
          ];
        in
          "$(~/.local/bin/fixup-path.sh \"${rawpath}\")";

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
          "$(~/.local/bin/fixup-path.sh \"${rawpath}\")";

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
          "$(~/.local/bin/fixup-path.sh \"${rawpath}\")";
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

      bash = {
        enable = true;

        initExtra = ''
          if [ -f ~/.env ] && [ -r ~/.env ]
          then
            . ~/.env
          fi
        '';

        profileExtra = ''
          if [ -f ~/.env ] && [ -r ~/.env ]
          then
            . ~/.env
          fi
        '';
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
        enableBashIntegration = true;
        enableZshIntegration = true;
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
            browser = "chromium";
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

      screen-locker = {
        enable = true;
        inactiveInterval = 20;
        lockCmd = "\${unstable.i3lock}/bin/i3lock -n -e -c 202020";
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
        for input in $(${unstable.xorg.xinput}/bin/xinput --list | ${unstable.coreutils}/bin/grep 'Logitech' | sed -r 's/.*\tid=([0-9]+)[^0-9].*$/\1/')
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
                };

                statusCommand = "${jellyfish.i3pystatus}/bin/i3pystatus -c ~/.config/i3pystatus/top.py";

                id = "bar-top";
                position = "top";

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

                statusCommand = "${jellyfish.i3pystatus}/bin/i3pystatus -c ~/.config/i3pystatus/bottom.py";

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

            keybindings = {
              "XF86AudioLowerVolume" = "exec \"${unstable.pamixer}/bin/pamixer --decrease 5";
              "XF86AudioMute" = "exec ~/.local/bin/toggle-mute.sh";
              "XF86AudioNext" = "exec ${unstable.playerctl}/bin/playerctl --player=spotify next";
              "XF86AudioPause" = "exec ${unstable.playerctl}/bin/playerctl --player=spotify play-pause";
              "XF86AudioPlay" = "exec ${unstable.playerctl}/bin/playerctl --player=spotify play-pause";
              "XF86AudioPrev" = "exec ${unstable.playerctl}/bin/playerctl --player=spotify previous";
              "XF86AudioRaiseVolume" = "exec \"${unstable.pamixer}/bin/pamixer --increase 5";

              "${modifier}+Return" = "exec ~/.local/bin/start-tmux-x.sh";
              "${modifier}+Shift+Return" = "exec ${unstable.st}/bin/st -e ${unstable.tmux}/bin/tmux new";

              "${modifier}+space" = "focus mode_toggle";
              "${modifier}+Shift+space" = "floating toggle";

              "${modifier}+minus" = "scratchpad show";
              "${modifier}+Shift+minus" = "move scratchpad";

              "${modifier}+equal" = "[class=\"^Spotify$\"] scratchpad show";

              "${modifier}+1" = "workspace number 1:disc";
              "${modifier}+Shift+1" = "move container to workspace number 1:disc";

              "${modifier}+2" = "workspace number 2:sys";
              "${modifier}+Shift+2" = "move container to workspace number 2:sys";

              "${modifier}+3" = "workspace number 3:mail";
              "${modifier}+Shift+3" = "move container to workspace number 3:mail";

              "${modifier}+4" = "workspace number 4:ffdoc";
              "${modifier}+Shift+4" = "move container to workspace number 4:ffdoc";

              "${modifier}+5" = "workspace number 5:ffxiv";
              "${modifier}+Shift+5" = "move container to workspace number 5:ffxiv";

              "${modifier}+6" = "workspace number 6";
              "${modifier}+Shift+6" = "move container to workspace number 6";

              "${modifier}+7" = "workspace number 7";
              "${modifier}+Shift+7" = "move container to workspace number 7";

              "${modifier}+8" = "workspace number 8:slack";
              "${modifier}+Shift+8" = "move container to workspace number 8:slack";

              "${modifier}+9" = "workspace number 9:misc";
              "${modifier}+Shift+9" = "move container to workspace number 9:misc";

              "${modifier}+0" = "workspace number 10:steam";
              "${modifier}+Shift+0" = "move container to workspace number 10:steam";

              "${modifier}+a" = "focus parent";
              "${modifier}+Shift+a" = "exec ~/.local/bin/passmenu --type";
              "${modifier}+Control+Shift+a" = "exec ~/.local/bin/passmenu";

              "${modifier}+Shift+b" = "exec ${unstable.pulseaudio}/bin/pactl suspend-sink 1 && ${unstable.pulseaudio}/bin/pactl suspend-sink 0";

              "${modifier}+c" = "focus child";
              "${modifier}+Control+c" = "${programs.chromium.package}/bin/chromium-browser";
              "${modifier}+Control+Shift+c" = "${programs.chromium.package}/bin/chromium-browser --incognito";

              "${modifier}+d" = "exec ${unstable.dmenu}/bin/dmenu_run";
              "${modifier}+Shift+d" = "exec ${unstable.i3}/bin/i3-dmenu-desktop";

              "${modifier}+e" = "layout toggle split";
              "${modifier}+Shift+e" = "exec \"i3-nagbar -t warning -m 'You pressed the exit shortcut. Do you really want to exit i3? This will end your X session.' -b 'Yes, exit i3' 'i3-msg exit & sleep 10 && loginctl terminate-session \$XDG_SESSION_ID'\"";

              "${modifier}+f" = "fullscreen toggle";
              "${modifier}+Control+Shift+f" = "${unstable.playonlinux}/bin/playonlinux --run 'FINAL FANTASY XIV - A Realm Reborn'";

              "${modifier}+Control+Shift+g" = "${unstable.xorg.xmodmap}/bin/xmodmap ${speedswapper}";

              "${modifier}+h" = "focus left";
              "${modifier}+Shift+h" = "move left";
              "${modifier}+Control+Shift+h" = "exec ${unstable.st}/bin/st -e ${unstable.htop}/bin/htop";

              "${modifier}+i" = "exec ${unstable.i3}/bin/i3-input";

              "${modifier}+j" = "focus down";
              "${modifier}+Shift+j" = "move down";

              "${modifier}+k" = "focus up";
              "${modifier}+Shift+k" = "move up";

              "${modifier}+l" = "focus right";
              "${modifier}+Shift+l" = "move right";
              "${modifier}+Control+Shift+l" = "exec \"sudo -K; i3lock -c 202020 -e\"";

              "${modifier}+Control+Shift+m" = "exec ${unstable.ftb}/bin/ftb-launch.sh";

              "${modifier}+n" = "workspace next";
              "${modifier}+Shift+n" = "move container to workspace next";
              "${modifier}+Control+n" = "exec ${unstable.playerctl}/bin/playerctl --player=spotify next";
              "${modifier}+Control+Shift+n" = "exec ${unstable.gnome3.nautilus}/bin/nautilus";

              "${modifier}+o" = "split h";

              "${modifier}+p" = "workspace prev";
              "${modifier}+Shift+p" = "move container to workspace prev";
              "${modifier}+Control+p" = "exec ${unstable.playerctl}/bin/playerctl --player=spotify previous";
              "${modifier}+Control+Shift+p" = "exec ${unstable.pavucontrol}/bin/pavucontrol";

              "${modifier}+Shift+q" = "kill";

              "${modifier}+r" = "mode \"resize\"";
              "${modifier}+Shift+r" = "exec i3-input -F 'rename workspace to \"%s\"' -P 'New name: '";
              "${modifier}+Control+r" = "reload";
              "${modifier}+Control+Shift+r" = "restart";

              "${modifier}+Shift+s" = "exec \"scrot -b -u -e 'pngcrush -brute -l 9 -reduce $f $f.crush.png && mv $f.crush.png $f' $(mktemp $(date '+/home/iamthememory/screenshots/screenshot-%Y-%m-%d-%H:%M:%S.%N%z.XXXX.png'))\"";
              "${modifier}+Control+s" = "exec \"${unstable.scrot}/bin/scrot -b -e 'pngcrush -brute -l 9 -reduce $f $f.crush.png && mv $f.crush.png $f' $(mktemp $(date '+/home/iamthememory/screenshots/screenshot-%Y-%m-%d-%H:%M:%S.%N%z.XXXX.png'))\"";
              "${modifier}+Control+Shift+s" = "exec \"${unstable.scrot}/bin/scrot -b -s -e '${unstable.pngcrush}/bin/pngcrush -brute -l 9 -reduce $f $f.crush.png && ${unstable.coreutils}/bin/mv $f.crush.png $f' $(${unstable.coreutils}/bin/mktemp $(date '+/home/iamthememory/screenshots/screenshot-%Y-%m-%d-%H:%M:%S.%N%z.XXXX.png'))\"";

              "${modifier}+t" = "mode \"passthrough\"";
              "${modifier}+Shift+t" = "exec ${unstable.xorg.xinput}/bin/xinput disable 'pointer:SynPS/2 Synaptics TouchPad'";
              "${modifier}+Control+Shift+t" = "exec ${unstable.xorg.xinput}/bin/xinput enable 'pointer:SynPS/2 Synaptics TouchPad'";

              "${modifier}+Control+Shift+u" = "exec ${unstable.systemd}/bin/systemctl suspend";

              "${modifier}+v" = "split v";

              "${modifier}+w" = "layout tabbed";

              "${modifier}+Control+Shift+x" = "exec ${unstable.xorg.xkill}/bin/xkill";

              "${modifier}+Shift+y" = "exec ${unstable.xorg.xinput}/bin/xinput disable 'Yubico Yubikey 4 OTP+U2F+CCID'";
              "${modifier}+Control+Shift+y" = "exec ${unstable.xorg.xinput}/bin/xinput enable 'Yubico Yubikey 4 OTP+U2F+CCID'";
            };

            modes = {
              "resize" = {
                "Return" = "mode \"default\"";
                "Escape" = "mode \"default\"";

                "h" = "resize shrink width 10 px or 5 ppt";
                "${modifier}+h" = "resize shrink width 1 px or 1 ppt";

                "j" = "resize grow height 10 px or 5 ppt";
                "${modifier}+j" = "resize grow height 1 px or 1 ppt";

                "k" = "resize shrink height 10 px or 5 ppt";
                "${modifier}+k" = "resize shrink height 1 px or 1 ppt";

                "l" = "resize grow width 10 px or 5 ppt";
                "${modifier}+l" = "resize grow width 1 px or 1 ppt";
              };

              "passthrough" = {
                "${modifier}+t" = "mode \"default\"";
              };
            };

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

            modifier = "Mod1";

            window = {
              border = 2;

              commands = [
                { command = "border none"; criteria = { instance = "^ffxiv\\.exe$"; }; }
              ];
            };
          };
        };
      };

      pointerCursor = {
        package = unstable.gnome3.adwaita-icon-theme;
        name = "Adwaita";
        size = 16;
      };
    };
  }
