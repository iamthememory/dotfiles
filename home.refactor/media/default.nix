# Media packages and configuration.
{ ...
}: {
  imports = [
    ./docs.nix
    ./images.nix
    ./video.nix
  ];

  # Add playerctld to track the last player for playerctl.
  services.playerctld.enable = true;
}
