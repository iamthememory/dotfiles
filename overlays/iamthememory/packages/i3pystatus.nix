{ self, super }:
  with (super // self); super.i3pystatus.override {
    extraLibs = [
      python3Packages.GeoIP
      python3Packages.dbus-python
      speedtest-cli
      zfs
    ];
  }
