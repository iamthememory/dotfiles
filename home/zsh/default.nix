{ config, lib, options, ... }:
let
  inherit (import ../channels.nix) unstable;

  pkgs = unstable;
in
  {
    home.packages = with unstable; [
      zsh
      zsh-completions
    ];

    programs.direnv.enableZshIntegration = true;

    programs.zsh = {
      enable = true;
      enableCompletion = true;

      dotDir = ".config/zsh";

      history = {
        extended = true;
        ignoreDups = true;
        save = 10000000;
        share = true;
        size = 10000000;
      };

      shellAliases = {
        egrep = "${pkgs.gnugrep}/bin/egrep --color=auto";
        fgrep = "${pkgs.gnugrep}/bin/fgrep --color=auto";
        grep = "${pkgs.gnugrep}/bin/grep --color=auto";
        ls = "${pkgs.coreutils}/bin/ls --color=auto";
        cp = "${pkgs.coreutils}/bin/cp --reflink=auto";
      };

      oh-my-zsh = {
        enable = true;

        plugins = [
          "autopep8"
          "catimg"
          "copyfile"
          "cpanm"
          "docker"
          "encode64"
          "extract"
          "git"
          "git-extras"
          "git-flow-avh"
          "history"
          "httpie"
          "lol"
          "npm"
          "pass"
          "pep8"
          "pip"
          "python"
          "sudo"
          "taskwarrior"
          "web-search"
        ];
      };

      plugins = [
        {
          name = "zsh-syntax-highlighting";
          src = builtins.fetchGit {
            url = "https://github.com/zsh-users/zsh-syntax-highlighting.git";
            ref = "master";
          };
        }
        {
          name = "liquidprompt";
          src = builtins.fetchGit {
            url = "https://github.com/nojhan/liquidprompt.git";
            ref = "master";
          };
        }
        {
          name = "nix-zsh-completions";
          src = builtins.fetchGit {
            url = "https://github.com/spwhitt/nix-zsh-completions.git";
            ref = "master";
          };
        }
      ];

      initExtra = ''
        # Don't display non-contiguous duplicates while searching with ^R.
        HIST_FIND_NO_DUPS=1

        # Use the system time binary, rather than the builtin
        disable -r time

        # Interactively choose from multiple completions.
        zstyle ':completion::complete:*' use-cache 1

        # Change CTRL-U to clear the line before the cursor, not the entire line.
        # This is more consistent with shells like bash.
        bindkey '^U' backward-kill-line

        # Just type a directory to cd into it.
        setopt autocd

        # Enable spelling correction for commands.
        setopt correct

        # Use extended globs.
        setopt extendedglob

        # Use timestamps in history.
        setopt extendedhistory

        # Use ksh-style extended globbing, e.g. @(foo|bar).
        setopt kshglob

        # If a glob has no matches, remove it.
        setopt nullglob

        # pushd alone goes to the home directory, like plain cd.
        setopt pushdtohome

        # Disable cd adding to the directory stack.
        unsetopt autopushd
      '';
    };
  }
