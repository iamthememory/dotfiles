# Various security and pentesting-related tools.
{ inputs
, pkgs
, ...
}: {
  home.packages =
    let
      gnuradio-custom = pkgs.gnuradio.override {
        extraPythonPackages = with pkgs.gnuradio.python.pkgs; [
          numpy
        ];
      };
    in
    with pkgs; [
      # A suite of tools for sniffing and cracking WiFi.
      aircrack-ng

      # A tool for generating memorable passphrases from a wordlist.
      diceware

      # A tool for monitoring ADS-B transmissions.
      dump1090-fa

      # A SDR framework.
      gnuradio-custom

      # A tool for receiving radio.
      inputs.stable.gqrx

      # Firmware tools for the HackRF.
      hackrf

      # A tool for cracking passwords.
      hashcat
      hashcat-utils

      # A tool to calibrate the HackRF tranceiver by locating cell tower baseband
      # frequencies.
      kalibrate-hackrf

      # The metasploit framework.
      metasploit

      # A tool for decoding transmissions.
      multimon-ng

      # Basic wordlists.
      netbsd.dict

      # A PCAP/BPF tool for grep-like operations on network data.
      ngrep

      # A tool for probing and scanning networks.
      nmap

      # A tool for generating random passwords.
      pwgen

      # The flipper GUI tool.
      qFlipper

      # A tool for viewing and recording network traffic on an interface.
      wireshark
    ];
}
