# Basic GUI setup.
{ ...
}: {
  imports = [
    ./dunst.nix
    ./fonts.nix
    ./kitty.nix
    ./locker.nix
  ];
}
