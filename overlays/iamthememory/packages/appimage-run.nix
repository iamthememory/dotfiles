{ super, self }:
  super.appimage-run.override {
    extraPkgs = pkgs: [
      pkgs.at_spi2_core.out
    ];
  }
