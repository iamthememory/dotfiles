# Media packages and configuration.
{ ...
}: {
  imports = [
    ./docs.nix
    ./images.nix
    ./video.nix
  ];

  # Add playerctld to track the last used media player for playerctl.
  services.playerctld.enable = true;
}
