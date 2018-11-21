{ pkgs, ... }:
  {
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

      package = pkgs.gitAndTools.gitFull;

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
        pkgs.tmuxPlugins.sensible
        {
          plugin = pkgs.tmuxPlugins.resurrect;
          extraConfig = ''
            set -g @resurrect-strategy-vim 'session'
          '';
        }
        {
          plugin = pkgs.tmuxPlugins.continuum;
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
        "vundle"
        "vim-colors-solarized"
        "vim-sensible"
        "vim-gitgutter"
        "vim-airline"
        "vim-airline-themes"
        "editorconfig-vim"
        "tagbar"
        "haskell-vim"
        "nerdtree"
        "vim-polyglot"
        "vim-dispatch"
        "vim-eunuch"
        "vim-fugitive"
        "vim-obsession"
        "nerdtree-git-plugin"
        "vim-devicons"
      ];
    };
  }
