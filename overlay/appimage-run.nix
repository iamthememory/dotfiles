# Customize appimage-run to add extra packages it should make available.
{ super
, ...
}: super.appimage-run.override {
  # Extra packages to make available.
  extraPkgs = pkgs: with pkgs; [
    at-spi2-core.out
  ];
}
