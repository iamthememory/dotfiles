# Various custom home-manager modules.
# FIXME: There is almost certainly a better way to do this.
{ ...
}: {
  imports = [
    ./system-settings.nix
  ];
}
