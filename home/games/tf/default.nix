{ inputs
, pkgs
, ...
}: {
  home.packages = with pkgs;
    let
      # A patched version of tinyfugue with newer features.
      tinyfugue-patched = tinyfugue.overrideDerivation
        (oldAttrs: rec {
          name = "tinyfugue-${version}";
          version = "5.1.0-${inputs.tinyfugue-patched.lastModifiedDate}";

          inherit openssl;
          sslSupport = true;

          configureFlags = "--enable-ssl --enable-python --enable-256colors --enable-atcp --enable-gmcp --enable-option102 --enable-lua --enable-widechar";

          patches = [
            ./0001-bold-is-bright.patch
            ./tinyfugue-94-gcc-14.patch
            ./0002-missing-includes.patch
          ];

          src = inputs.tinyfugue-patched;

          buildInputs = with pkgs; oldAttrs.buildInputs ++ [
            icu.dev
            lua5_4
            pcre.dev
            python3
          ];

          nativeBuildInputs = with pkgs; oldAttrs.buildInputs ++ [
            pkg-config
          ];
        });
    in
    [
      tinyfugue-patched
    ];
}
