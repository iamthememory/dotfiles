# Virtualization-related configuration.
{ lib
, pkgs
, ...
}: {
  home.packages = with pkgs; [
    # The Docker client.
    docker

    # Libvirt tools.
    libvirt

    # QEMU utilities for manipulating VMs and their disk images.
    qemu-utils

    # A tool for managing libvirt VMs.
    virtmanager
  ];

  # Default to controlling the system's KVM VMs.
  home.sessionVariables.LIBVIRT_DEFAULT_URI =
    lib.mkDefault "qemu:///system";
}
