{ self, super }:
  super.winetricks.override {
    wine = self.wineStaging;
  }
