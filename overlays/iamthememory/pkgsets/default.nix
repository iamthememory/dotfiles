{ pkgs, ... }:
with pkgs;
  rec {
    cli-base         = import ./cli-base.nix         { inherit pkgs; };
    cli-devel        = import ./cli-devel.nix        { inherit pkgs; };
    cli-games        = import ./cli-games.nix        { inherit pkgs; };
    cli-media        = import ./cli-media.nix        { inherit pkgs; };
    cli-netutilities = import ./cli-netutilities.nix { inherit pkgs; };
    cli-utilities    = import ./cli-utilities.nix    { inherit pkgs; };
    gui-base         = import ./gui-base.nix         { inherit pkgs; };
    gui-fonts        = import ./gui-fonts.nix        { inherit pkgs; };
    gui-games        = import ./gui-games.nix        { inherit pkgs; };
    gui-media        = import ./gui-media.nix        { inherit pkgs; };
    gui-netutilities = import ./gui-netutilities.nix { inherit pkgs; };
    gui-utilities    = import ./gui-utilities.nix    { inherit pkgs; };

    # Interpreters.
    cli-languages = [
      R
      #androidndk
      #androidsdk_extras
      #cabal-install
      #cabal2nix
      gnuplot
      #go
      #mono
      octave
      perl
      perlPackages.Appcpanminus
      ruby
      #rustc
      python2
      python3
    ];


    # Development environments.
    dev-envs = with envs.devel; [
      cpp
    ];


    # All CLI packages.
    cli-full =
      cli-base
      ++ dev-envs
      ++ cli-devel
      ++ cli-games
      ++ cli-languages
      ++ cli-media
      ++ cli-netutilities
      ++ cli-utilities;


    # All GUI packages.
    gui-full =
      cli-full
      ++ gui-base
      ++ gui-games
      ++ gui-media
      ++ gui-netutilities
      ++ gui-utilities;
  }
