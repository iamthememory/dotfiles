# Network-related functions.
{ lib
, ...
}: rec {
  # Make a NetworkManager network definition.
  mkNetwork =
    network:
    let
      # Format a value the default way, but allow lists to be specified with
      # each element terminated with a semicolon, since NetworkManager uses that
      # to specify multiple values.
      formatValue = v:
        if lib.isList v
        then lib.concatMapStrings (x: x + ";") v
        else lib.generators.mkValueStringDefault { } v;

      # Format an INI file with the above for formatting values.
      toINI = lib.generators.toINI {
        mkKeyValue = lib.generators.mkKeyValueDefault
          {
            mkValueString = formatValue;
          }
          "=";
      };

      # Default options that should work for most networks.
      defaultOptions = {
        connection.permissions = "";

        ipv4.dns-search = "";
        ipv4.method = "auto";

        ipv6.addr-gen-mode = "stable-privacy";
        ipv6.dns-search = "";
        ipv6.method = "auto";
      };
    in
    {
      target =
        "NetworkManager/system-connections/${network.connection.id}.nmconnection";

      text = toINI (lib.recursiveUpdate defaultOptions network);
    };

  # Make an ethernet network definition.
  mkEthernet =
    network:
    let
      defaultOptions = {
        connection.type = "ethernet";

        ethernet.mac-address-blacklist = "";
      };
    in
    mkNetwork (lib.recursiveUpdate defaultOptions network);

  # Make a Wifi network definition.
  mkWifi =
    network:
    let
      defaultOptions = {
        connection.type = "wifi";

        wifi.mac-address-blacklist = "";
        wifi.mode = "infrastructure";
        wifi.ssid = network.connection.id;

        wifi-security.key-mgmt = "wpa-psk";
      };
    in
    mkNetwork (lib.recursiveUpdate defaultOptions network);
}
