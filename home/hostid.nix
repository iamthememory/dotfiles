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

  isin = list: host: builtins.any (x: x == host) list;
in
{
  hostname = host;

  hasGui = isin gui_hosts host;
}
