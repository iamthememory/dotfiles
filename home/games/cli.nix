# Terminal-based games and their configuration.
{ inputs
, lib
, pkgs
, ...
}: {
  imports = [
    ./tf
  ];

  home.packages = with pkgs; [
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
