{ self, super }:
  with (super // self); super.i3pystatus.overrideAttrs (oldAttrs: rec {
    propagatedBuildInputs = oldAttrs.propagatedBuildInputs ++ [
      python3Packages.GeoIP
      python3Packages.dbus-python
      speedtest-cli
      zfs
    ];
      version = "unstable-2019-02-22";
      src = fetchFromGitHub {
        owner = "enkore";
        repo = "i3pystatus";
        rev = "bcd8f12b18d491029fdd5bd0f433b4500fcdc68e";
        sha256 = "0gw6sla73cid6gwxn2n4zmsg2svq5flf9zxly6x2rfljizgf0720";
      };
  })
