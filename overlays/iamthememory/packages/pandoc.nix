{ self, super }:
  super.pandoc.overrideDerivation (oldAttrs: {
    buildInputs = oldAttrs.buildInputs ++ [ super.texlive.combined.scheme-full ];
  })
