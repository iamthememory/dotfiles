{ pkgs, ... }:
with pkgs;
  # Basic packages.
  [
    bash-completion
    bashInteractive
    direnv
    file
    git-lfs
    gitAndTools.gitflow
    gitFull
    gnupg
    man
    nix-index
    nix-prefetch-git
    time
    tmux
    #vimHugeX
    xdg-user-dirs
    zsh
    zsh-completions
  ]
