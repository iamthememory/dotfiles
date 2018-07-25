with import <nixpkgs> {};

rec {
  allowUnfree = true;

  packageOverrides = pkgs: rec {
    custpkgs = import ./packages.nix {
      inherit pkgs;
    };

    utilities = import ./utilities.nix {
      inherit pkgs;
    };
    # My graphical packages.
    gui-packages = with pkgs; mkenv "gui-packages" [
      i3pystatus
      nerdfonts
      powerline-fonts
      st
      unclutter-xfixes
    ];


    # My CLI media.
    cli-media = with pkgs; mkenv "cli-media-packages" [
      nethack
    ];


    # My development tools.
    devel = with pkgs; mkenv "devel-packages" [
      bumpversion
      ctags
    ];


    # Nice utilities.
    utilities = with pkgs; mkenv "utility-packages" [
      diceware
      nix-repl
      pandoc
    ];


    # Interpreters.
    languages = with pkgs; mkenv "language-packages" [
      R
      perl
      ruby
      python2
      python3
    ];


    # My basic packages.
    base = with pkgs; mkenv "base-packages" [
      ack
      gitFull
      gnupg
      man
      tmux
      vimHugeX
      zsh
    ];


    # CLI packages.
    cli-full = with pkgs; mkenv "cli-full" [
      base
      cli-media
      devel
      utilities
      languages
    ];


    # GUI packages.
    gui-full = with pkgs; mkenv "gui-full" [
      cli-full
      gui-packages
    ];

  };
}
