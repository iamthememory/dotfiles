{ self, super }:
  super.python3Packages.scikitlearn.overrideAttrs (oldAttrs: {
    patches = [ ./lda-tolerance-numpy-1.17.0.patch ];
  })
