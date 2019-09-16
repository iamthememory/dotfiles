{ self, super }:
  (super.python3Packages or {}) // {
    GeoIP = import ./GeoIP.nix { inherit self super; };
    scikitlearn = import ./scikitlearn { inherit self super; };
  }
