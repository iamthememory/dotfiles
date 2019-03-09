let
  inherit (import ./channels.nix) stable unstable jellyfish staging;

  host = import ~/host.nix;

  known_hosts = [
    "aurora"
    "nightmare"
  ];

  gui_hosts = [
    "aurora"
    "nightmare"
  ];

  game_hosts = [
    "nightmare"
  ];

  gpg_keys = {
    nightmare = "0xD226B54765D868B7";
    aurora = "0x18EAD8C06EBF0479";
  };

  interfaces = {
    nightmare = "wlp5s0";
    aurora = "wlp2s0";
  };

  i3pyTempFormats = {
    aurora = "{Package_id_0}°C {Package_id_0_bar}{Core_0_bar}{Core_1_bar}{Core_2_bar}{Core_3_bar}";
    nightmare = "FIXME {temp}°C";
  };

  isin = list: host: builtins.any (x: x == host) list;
in
rec {
  hostname = host;

  hasGui = isin gui_hosts host;

  hasGames = isin game_hosts host;

  gpgKey = gpg_keys."${hostname}";

  defaultInterface = interfaces."${hostname}";

  i3pystatusTempFormat = i3pyTempFormats."${hostname}";
}
