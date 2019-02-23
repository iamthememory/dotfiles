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

  isin = list: host: builtins.any (x: x == host) list;
in
rec {
  hostname = host;

  hasGui = isin gui_hosts host;

  hasGames = isin game_hosts host;

  gpgKey = gpg_keys."${hostname}";
}
