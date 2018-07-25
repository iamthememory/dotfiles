with import <nixpkgs> {};

rec {
  allowUnfree = true;

  packageOverrides = pkgs: rec {
    custpkgs = import ./packages.nix {
      inherit pkgs;
    };

    pkgsets = import ./pkgsets.nix {
      inherit custpkgs envs pkgs;
    };

    utilities = import ./utilities.nix {
      inherit pkgs pkgsets;
    };

    envs = import ./envs.nix {
      inherit custpkgs pkgs pkgsets utilities;
    };
  };
}
