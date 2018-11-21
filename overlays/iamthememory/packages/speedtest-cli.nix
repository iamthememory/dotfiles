{ self, super }:
  super.python3Packages.buildPythonPackage rec {
    inherit (super.speedtest-cli) name version meta src;
  }
