{ self, super }:
  super.wineStaging.override {
    wineBuild = "wineWow";
  }
