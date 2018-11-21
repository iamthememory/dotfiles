{ self, super }:
  with (super // self); super.tinyfugue.overrideDerivation (oldAttrs: rec {
    name = "tinyfugue-${version}";
    version = "50b9";

    inherit openssl;
    sslSupport = true;

    configureFlags = "--enable-ssl --enable-python --enable-256colors --enable-atcp --enable-gmcp --enable-option102 --enable-lua";

    src = fetchFromGitHub {
      owner = "ingwarsw";
      repo = "tinyfugue";
      rev = "d30f526fd32d2079f38fc7f39eded2e0872cdcea";
      sha256 = "1ivnlnngxbff8l3w7n20aypfqvs78kzjdzn73ryk6fg0nzaaax4h";
    };

    buildInputs =  with pkgs; oldAttrs.buildInputs ++ [
      lua
      pcre.dev
      python3
    ];
  })
