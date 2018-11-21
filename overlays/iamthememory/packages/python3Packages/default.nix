{ self, super }:
  (super.python3Packages or {}) // {
    GeoIP = import ./GeoIP.nix { inherit self super; };
  }
