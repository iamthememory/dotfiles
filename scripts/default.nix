{ pkgs
, ...
}:
let
  mkScript = f: o: import f ({ inherit pkgs; } // o);
in
rec {
  fixup-paths = mkScript ./fixup-paths.nix { };
  truecolor-support = mkScript ./truecolor-support.nix { };
}
