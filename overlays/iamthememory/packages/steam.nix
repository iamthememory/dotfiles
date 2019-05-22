{ self, super }:
  super.steam.override {
    extraPkgs = pkgs: with pkgs; [
      gtk3-x11
      libva1
      python3
    ];
  }
