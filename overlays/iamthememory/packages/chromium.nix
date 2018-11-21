{ super, self }:
  super.chromium.overrideDerivation (oldAttrs: {
    enableNacl = true;
    gnomeKeyringSupport = true;
    proprietaryCodecs = true;
    enablePepperFlash = true;
    enableWideVine = true;
    pulseSupport = true;
  })
