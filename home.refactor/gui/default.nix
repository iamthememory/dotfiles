# Basic GUI setup.
{ ...
}: {
  imports = [
    ./fonts.nix
    ./kitty.nix
    ./locker.nix
  ];
}
