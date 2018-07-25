with import <nixpkgs> {};

rec {
  allowUnfree = true;

  packageOverrides = pkgs: rec {

    mkenv = name: packages: pkgs.buildEnv {
      inherit name;
      paths = packages ++ [ pkgs.texinfoInteractive ];

      pathsToLink = [
        "/bin"
        "/etc"
        "/share/doc"
        "/share/fonts"
        "/share/info"
        "/share/man"
      ];

      extraOutputsToInstall = [
        "devdoc"
        "doc"
        "info"
        "man"
      ];
      postBuild = ''
        if [ -x $out/bin/install-info -a -w $out/share/info ]; then
          shopt -s nullglob
          for i in $out/share/info/*.info $out/share/info/*.info.gz; do
              $out/bin/install-info $i $out/share/info/dir
          done
        fi
      '';
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
