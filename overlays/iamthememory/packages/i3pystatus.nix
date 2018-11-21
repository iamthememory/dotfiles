{ self, super }:
  with (super // self); super.i3pystatus.override {
    extraLibs = [
      python3Packages.GeoIP
      speedtest-cli
      zfs
    ];
  }
