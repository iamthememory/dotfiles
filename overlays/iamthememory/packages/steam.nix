{ self, super }:
  super.steam.override {
    extraPkgs = pkgs: with pkgs; [
      gtk3-x11
      liberation_ttf
      libva1.out
      python3
    ];
  }
