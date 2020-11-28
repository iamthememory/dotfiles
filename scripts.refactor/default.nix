{
  pkgs,
  ...
}: let
  mkScript = f: o: import f ({ inherit pkgs; } // o);
in rec {
  fixup-paths = mkScript ./fixup-paths.nix {};
}
