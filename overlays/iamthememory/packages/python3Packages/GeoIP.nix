{ self, super }:
  super.python3Packages.GeoIP.override {
    geoip = super.geoipWithDatabase;
  }
