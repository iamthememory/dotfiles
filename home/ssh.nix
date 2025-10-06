# Configuration for the SSH client.
{ config
, pkgs
, ...
}: {
  home.packages = with pkgs; [
    # Install SSH.
    openssh
  ];

  # Enable SSH's configuration.
  programs.ssh.enable = true;
  programs.ssh.enableDefaultConfig = false;

  # Enable SSH compression.
  programs.ssh.matchBlocks."*".compression = true;

  # Multiplex multiple sessions over a single connection when possible.
  programs.ssh.matchBlocks."*".controlMaster = "auto";

  # The path to the control socket when multiplexing sessions.
  programs.ssh.matchBlocks."*".controlPath =
    "${config.home.homeDirectory}/.ssh/control-%r@%h:%p";

  # Keep control sockets open in the background for ten minutes.
  programs.ssh.matchBlocks."*".controlPersist = "10m";

  # Don't forward local authentication to the remote side.
  programs.ssh.matchBlocks."*".forwardAgent = false;

  # Hash hostnames and addresses when adding them to the known hosts file to
  # lessen information leaking.
  programs.ssh.matchBlocks."*".hashKnownHosts = true;

  # Send a keepalive every 30 seconds.
  programs.ssh.matchBlocks."*".serverAliveInterval = 30;

  # The file for known hosts.
  programs.ssh.matchBlocks."*".userKnownHostsFile =
    "${config.home.homeDirectory}/.ssh/known_hosts";
}
