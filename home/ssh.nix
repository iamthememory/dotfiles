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
  programs.ssh.settings."*".compression = true;

  # Multiplex multiple sessions over a single connection when possible.
  programs.ssh.settings."*".controlMaster = "auto";

  # The path to the control socket when multiplexing sessions.
  programs.ssh.settings."*".controlPath =
    "${config.home.homeDirectory}/.ssh/control-%r@%h:%p";

  # Keep control sockets open in the background for ten minutes.
  programs.ssh.settings."*".controlPersist = "10m";

  # Don't forward local authentication to the remote side.
  programs.ssh.settings."*".forwardAgent = false;

  # Hash hostnames and addresses when adding them to the known hosts file to
  # lessen information leaking.
  programs.ssh.settings."*".hashKnownHosts = true;

  # Send a keepalive every 30 seconds.
  programs.ssh.settings."*".serverAliveInterval = 30;

  # The file for known hosts.
  programs.ssh.settings."*".userKnownHostsFile =
    "${config.home.homeDirectory}/.ssh/known_hosts";

  # Enable ssh-agent.
  services.ssh-agent.enable = true;

  # Keep keys for an hour.
  services.ssh-agent.defaultMaximumIdentityLifetime = 3600;
}
