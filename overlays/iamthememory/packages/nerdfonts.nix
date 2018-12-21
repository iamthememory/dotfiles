{ self, super }:
  let
    python = (self // super).python.withPackages (
      ps: with ps; [
          configparser
          fontforge
        ]
    );
  in
  with (super // self); super.nerdfonts.overrideDerivation (oldAttrs: rec {
    buildInputs =  with pkgs; oldAttrs.buildInputs ++ [
      bc
      powerline-fonts
      python
    ];

    patchPhase = oldAttrs.patchPhase + ''
      sed -i -e 's|/bin/bash|${bash}/bin/bash|g' bin/scripts/*.sh
      rm src/unpatched-fonts/LiberationMono/*.ttf
      cp -v ${powerline-fonts}/share/fonts/truetype/Literation\ Mono*.ttf src/unpatched-fonts/LiberationMono
      rm -rfv patched-fonts/LiberationMono
      pushd bin/scripts
      ./standardize-and-complete-readmes.sh
      popd
    '';

    buildPhase = ''
      pushd bin/scripts
      PYTHONIOENCODING=utf-8 ./gotta-patch-em-all-font-patcher\!.sh Literation
      popd
    '';
  })
