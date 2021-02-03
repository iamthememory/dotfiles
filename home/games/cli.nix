# Terminal-based games and their configuration.
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
          version = "50b9-${inputs.tinyfugue-patched.lastModifiedDate}";

          inherit openssl;
          sslSupport = true;

          configureFlags = "--enable-ssl --enable-python --enable-256colors --enable-atcp --enable-gmcp --enable-option102 --enable-lua";

          src = inputs.tinyfugue-patched;

          buildInputs = with pkgs; oldAttrs.buildInputs ++ [
            lua
            pcre.dev
            python3
          ];
        });
    in
    [
      # A rogue-like.
      nethack

      # A client for playing MUDs.
      tinyfugue-patched
    ];

  # Configuration for nethack.
  home.file.".nethackrc".text = ''
    AUTOPICKUP_EXCEPTION=">chest"
    AUTOPICKUP_EXCEPTION=">corpse"
    AUTOPICKUP_EXCEPTION=">large box"
    AUTOPICKUP_EXCEPTION=">rock"
    OPTIONS=!autopickup
    OPTIONS=catname:Tiger Lily
    OPTIONS=checkpoint
    OPTIONS=color
    OPTIONS=dogname:Daisy
    OPTIONS=gender:female
    OPTIONS=name:Clarissa
    OPTIONS=paranoid_confirmation:quit attack pray wand Remove
    OPTIONS=safe_pet
    OPTIONS=showexp
    OPTIONS=showscore
    OPTIONS=sortloot:full
    OPTIONS=sortpack
    OPTIONS=standout
    OPTIONS=time
    OPTIONS=windowtype:tty
  '';
}
