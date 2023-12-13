# Customize Steam to add extra dependencies it should make available.
{ super
, ...
}: super.steam.override {
  # Extra packages to make available.
  extraPkgs = pkgs: with pkgs; [
    fluidsynth
    freetype
    gtk3-x11
    icu
    libbsd
    liberation_ttf
    libva1
    mesa
    python3
  ];
}
