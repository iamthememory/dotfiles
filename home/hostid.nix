let
  inherit (import ./channels.nix) stable unstable jellyfish staging;

  host = import ~/host.nix;

  known_hosts = [
    "nightmare"
  ];

  gui_hosts = [
    "aurora"
    "nightmare"
  ];

  game_hosts = [
    "nightmare"
  ];

  isin = list: host: builtins.any (x: x == host) list;
in
{
  hostname = host;

  hasGui = isin gui_hosts host;

  hasGames = isin game_hosts host;
}
