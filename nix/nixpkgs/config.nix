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

    # My basic packages.
    base = pkgs.buildEnv {
      name = "base-packages";
      paths = with pkgs; [
        R
        ack
        bumpversion
        ctags
        diceware
        gitFull
        gnupg
        go
        i3pystatus
        man
        nerdfonts
        nethack
        nix-repl
        pandoc
        perl
        powerline-fonts
        ruby
        st
        texinfoInteractive
        tmux
        vimHugeX
        zsh
      ];

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

  };
}