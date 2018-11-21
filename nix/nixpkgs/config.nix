with import <nixpkgs> {};
  let
    custpkgs = import ./packages.nix;
  in
  rec {
    allowUnfree = true;

    packageOverrides = pkgs: rec {
      inherit custpkgs;

      pkgsets = import ./pkgsets.nix {
        inherit pkgs;
      };

      utilities = import ./utilities.nix {
        inherit pkgs;
      };

      envs = import ./envs.nix {
        inherit pkgs;
      };
    };
  }
