# Terminal-based games and their configuration.
{ inputs
, lib
, pkgs
, ...
}: {
  imports = [
    ./tf
  ];

  home.packages =
    let
      # A more up-to-date blightmud.
      # FIXME: Remove this once blightmud in nixpkgs is updated.
      blightmud-latest = pkgs.blightmud-tts.overrideAttrs (final: old: rec {
        src = inputs.blightmud;

        version = inputs.blightmud.lastModifiedDate;
        name = "${old.pname}-${final.version}";

        # Replace the dependencies from the lock file.
        cargoDeps = pkgs.rustPlatform.importCargoLock {
          lockFile = "${inputs.blightmud}/Cargo.lock";
        };

        # Skip an additional test.
        checkFlags = old.checkFlags + " --skip test_is_connected";

        # TTS isn't broken on 3.6.2 apparently.
        meta = lib.filterAttrs (n: v: n != "broken") old.meta;
      });
    in
    with pkgs; [
      # A MUD client written in rust.
      blightmud-latest

      # A rogue-like.
      nethack
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
