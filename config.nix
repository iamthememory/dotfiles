with import <nixpkgs> {};
  {
    allowUnfree = true;

    android_sdk = {
      accept_license = true;
    };

    chromium = {
      enablePepperFlash = true;
      #enableWideVine = true;
    };

    retroarch = {
      enable4do = true;
      enableBeetlePCEFast = true;
      enableBeetlePSX = true;
      enableBeetleSaturn = true;
      enableBsnesMercury = true;
      enableDesmume = true;
      enableDolphin = true;
      enableFBA = true;
      enableFceumm = true;
      enableGambatte = true;
      enableGenesisPlusGX = true;
      enableHiganSFC = true;
      enableMAME = true;
      enableMGBA = true;
      enableMupen64Plus = true;
      enableNestopia = true;
      enableParallelN64 = true;
      enablePicodrive = true;
      enablePrboom = true;
      enablePPSSPP = true;
      enableQuickNES = true;
      enableReicast = true;
      enableScummVM = true;
      enableSnes9x = true;
      enableSnes9xNext = true;
      enableStella = true;
      enableVbaNext = true;
      enableVbaM = true;
    };
  }
