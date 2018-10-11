{
  pkgs,
}:
with pkgs; rec {
  bumpversion = with pkgs.pythonPackages; buildPythonApplication rec {
    version = "0.5.3";
    pname = "bumpversion";

    src = fetchPypi {
      inherit pname version;
      sha256 = "6744c873dd7aafc24453d8b6a1a0d6d109faf63cd0cd19cb78fd46e74932c77e";
    };
  };

  chromium = pkgs.chromium.overrideDerivation (oldAttrs: {
    enableNacl = true;
    gnomeKeyringSupport = true;
    proprietaryCodecs = true;
    enablePepperFlash = true;
    enableWideVine = true;
    pulseSupport = true;
  });

  ftb = pkgs.buildFHSUserEnv {
    name = "ftb";
    targetPkgs = pkgs_: with pkgs_; [
      jdk8
      xorg.libXxf86vm
      xorg.xrandr
      (stdenv.mkDerivation rec {
        name = "ftblauncher";

        src = fetchurl {
          url = "http://ftb.cursecdn.com/FTB2/launcher/FTB_Launcher.jar";
          sha256 = "0pyh83hhni97ryvz6yy8lyiagjrlx67cwr780s2bja92rxc1sqpj";
        };

        builder = builtins.toFile "builder.sh" ''
          source $stdenv/setup
          mkdir -pv $out/lib/ftb
          cp -v $src $out/lib/ftb/FTB_Launcher.jar
        '';
      })
    ];
    runScript = writeScript "ftb.sh" ''
      #!${stdenv.shell}
      exec /bin/java -jar /lib/ftb/FTB_Launcher.jar
    '';
  };

  GeoIP = pkgs.python3Packages.GeoIP.override {
    geoip = pkgs.geoipWithDatabase;
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

  gnupg = with pkgs; pkgs.gnupg.override {
    inherit pinentry adns gnutls libusb openldap readline zlib bzip2;
    guiSupport = true;
  };

  i3pystatus = pkgs.i3pystatus.override {
    extraLibs = [
      GeoIP
      pkgs.zfs
      speedtest-cli
    ];
  };

  nxBender = with pkgs.pythonPackages; buildPythonApplication rec {
    pname = "nxBender";
    version = "454dedc6c72fc62eedb7be18e62c6b7ee5f82bb3";
    propagatedBuildInputs = [
      ConfigArgParse
      ipaddress
      requests
      ppp
      pyroute2
    ];
    src = fetchFromGitHub {
      owner = "larswolter";
      repo = "nxBender";
      rev = "43c2c545afba84b66a74cbead0396ae798fddc96";
      sha256 = "03shyfjnr1mywliy7imvc0yjbh03q1fljaw02l19ad0syccz8nkz";
    };
  };

  pandoc = pkgs.pandoc.overrideDerivation (oldAttrs: {
    buildInputs = oldAttrs.buildInputs ++ [ pkgs.texlive.combined.scheme-full ];
  });

  pydf = with pkgs.pythonPackages; buildPythonApplication rec {
    version = "12";
    pname = "pydf";

    src = fetchPypi {
      inherit pname version;
      sha256 = "7f47a7c3abfceb1ac04fc009ded538df1ae449c31203962a1471a4eb3bf21439";
    };
  };

  speedtest-cli = pkgs.python3Packages.buildPythonPackage rec {
    inherit (pkgs.speedtest-cli) name version meta src;
  };

  st = pkgs.st.override {
    conf = builtins.readFile ~/dotfiles/st/st-0.8.1.h;
    patches = [
      ~/dotfiles/st/patches/st-no_bold_colors-0.8.1.patch
    ];
  };

  steam = pkgs.steam.override {
    extraPkgs = pkgs: with pkgs; [
      python3
    ];
  };

  steam-run = (steam.override {
    nativeOnly = true;
  }).run;

  tinyfugue = pkgs.tinyfugue.overrideDerivation (oldAttrs: rec {
    name = "tinyfugue-${version}";
    version = "50b9";

    inherit openssl;
    sslSupport = true;

    configureFlags = "--enable-ssl --enable-python --enable-256colors --enable-atcp --enable-gmcp --enable-option102 --enable-lua";

    src = fetchFromGitHub {
      owner = "ingwarsw";
      repo = "tinyfugue";
      rev = "d30f526fd32d2079f38fc7f39eded2e0872cdcea";
      sha256 = "1ivnlnngxbff8l3w7n20aypfqvs78kzjdzn73ryk6fg0nzaaax4h";
    };

    buildInputs =  with pkgs; oldAttrs.buildInputs ++ [
      lua
      pcre.dev
      python3
    ];
  });

  wine32 = pkgs.wineStaging;

  wineStaging = pkgs.wineStaging.override {
    wineBuild = "wineWow";
  };

  winetricks = pkgs.winetricks.override {
    wine = wineStaging;
  };
}
