# Configuration for the SSH client.
{ pkgs
, ...
}: {
  home.packages = with pkgs; [
    # Install SSH.
    openssh
  ];

  # Enable SSH's configuration.
  programs.ssh.enable = true;

  # Enable SSH compression.
  programs.ssh.compression = true;

  # Multiplex multiple sessions over a single connection when possible.
  programs.ssh.controlMaster = "auto";

  # The path to the control socket when multiplexing sessions.
  programs.ssh.controlPath = "~/.ssh/control-%r@%h:%p";

  # Keep control sockets open in the background for ten minutes.
  programs.ssh.controlPersist = "10m";

  # Hash hostnames and addresses when adding them to the known hosts file to
  # lessen information leaking.
  programs.ssh.hashKnownHosts = true;

  # Send a keepalive every 30 seconds.
  programs.ssh.serverAliveInterval = 30;
}
