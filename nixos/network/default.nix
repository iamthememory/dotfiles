# Networking configuration.
{ lib
, ...
}: {
  # Enable WireGuard.
  networking.wireguard.enable = true;

  # Enable mtr, a traceroute-like ncurses utility.
  programs.mtr.enable = true;

  # Enable traceroute.
  programs.traceroute.enable = true;

  # Enable openssh.
  services.openssh.enable = true;

  # By default, disallow root SSH logins.
  services.openssh.permitRootLogin = "no";

  # Block addresses that attempt to brute force passwords.
  services.sshguard.enable = true;

  # More readily block brute force attempts.
  services.sshguard.attack_threshold = 10;
}
