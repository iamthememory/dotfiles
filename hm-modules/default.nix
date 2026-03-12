# Various custom home-manager modules.
# FIXME: There is almost certainly a better way to do this.
{ ...
}: {
  imports = [
    ./itd.nix
    ./system-settings.nix
  ];
}
