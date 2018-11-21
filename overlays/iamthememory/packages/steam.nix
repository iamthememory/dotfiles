{ self, super }:
  super.steam.override {
    extraPkgs = pkgs: with pkgs; [
      python3
    ];
  }
