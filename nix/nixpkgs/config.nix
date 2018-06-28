with import <nixpkgs> {};

rec {
  allowUnfree = true;

  packageOverrides = pkgs: rec {

    speedtest-cli = pkgs.python3Packages.buildPythonPackage rec {
      inherit (pkgs.speedtest-cli) name version meta src;
    };

    GeoIP = pkgs.python3Packages.GeoIP.override {
      geoip = pkgs.geoipWithDatabase;
    };

    i3pystatus = pkgs.i3pystatus.override {
      extraLibs = [ GeoIP speedtest-cli ];
    };

    bumpversion = with pkgs.pythonPackages; buildPythonApplication rec {
      version = "0.5.3";
      pname = "bumpversion";

      src = fetchPypi {
        inherit pname version;
        sha256 = "6744c873dd7aafc24453d8b6a1a0d6d109faf63cd0cd19cb78fd46e74932c77e";
      };
    };

    gnupg = with pkgs; pkgs.gnupg.override {
      inherit pinentry adns gnutls libusb openldap readline zlib bzip2;
      guiSupport = true;
    };

    gitFull = pkgs.gitAndTools.gitFull.overrideDerivation (oldAttrs: {
      buildInputs = with pkgs; oldAttrs.buildInputs ++ [ pkgconfig libsecret.dev ];

      postBuild = oldAttrs.postBuild + ''
        pushd $PWD/contrib/credential/libsecret
        make
        popd
      '';

      preInstall = oldAttrs.preInstall + ''
        mkdir -p $out/bin
        cp -a $PWD/contrib/credential/libsecret/git-credential-libsecret $out/bin
        rm -f $PWD/contrib/credential/libsecret/git-credential-libsecret.o
      '';
    });

    pandoc = pkgs.pandoc.overrideDerivation (oldAttrs: {
      buildInputs = oldAttrs.buildInputs ++ [ pkgs.texlive.combined.scheme-basic ];
    });

    st = pkgs.st.override {
      conf = builtins.readFile ~/dotfiles/st/st-0.8.1.h;
    };

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
