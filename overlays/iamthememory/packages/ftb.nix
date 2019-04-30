{ self, super }:
  with super; buildFHSUserEnv {
    name = "ftb";
    targetPkgs = pkgs_: with pkgs_; [
      jdk8
      pulseaudio
      xorg.libXxf86vm
      xorg.xrandr
      (stdenv.mkDerivation rec {
        name = "ftblauncher";

        src = fetchurl {
          url = "http://ftb.cursecdn.com/FTB2/launcher/FTB_Launcher.jar";
          sha256 = "0c60nbddxs8mv6i7g5dz365sfjrdq9pk12xggk4bm4px7xg5gv7j";
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
  }
