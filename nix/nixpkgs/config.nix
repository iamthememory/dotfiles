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

    # My basic packages.
    base = pkgs.buildEnv {
      name = "base-packages";
      paths = with pkgs; [
        i3pystatus
        man
        texinfoInteractive
        zsh
      ];

      pathsToLink = [
        "/bin"
        "/etc"
        "/share/doc"
        "/share/info"
        "/share/man"
      ];

      extraOutputsToInstall = [
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
