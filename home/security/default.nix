# Various security and pentesting-related tools.
{ pkgs
, ...
}: {
  home.packages = with pkgs; [
    # A suite of tools for sniffing and cracking WiFi.
    aircrack-ng

    # A tool for generating memorable passphrases from a wordlist.
    diceware

    # Firmware tools for the HackRF.
    hackrf

    # A tool to calibrate the HackRF tranceiver by locating cell tower baseband
    # frequencies.
    kalibrate-hackrf

    # The metasploit framework.
    metasploit

    # Basic wordlists.
    netbsd.dict

    # A PCAP/BPF tool for grep-like operations on network data.
    ngrep

    # A tool for probing and scanning networks.
    nmap

    # A tool for generating random passwords.
    pwgen

    # A tool for viewing and recording network traffic on an interface.
    wireshark
  ];
}
