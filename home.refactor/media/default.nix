# Media packages and configuration.
{ ...
}: {
  imports = [
    ./docs.nix
    ./images.nix
    ./video.nix
  ];
}
