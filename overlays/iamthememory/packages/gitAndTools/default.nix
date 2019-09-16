{ self, super }:
let
  patchgit = pkg: pkg.overrideAttrs (oldAttrs: {
    preInstallCheck = oldAttrs.preInstallCheck + ''
      # Fails on ZFS.
      disable_test t3910-mac-os-precompose
    '';
  });
in
  (super.gitAndTools or {}) // {
    gitFull = patchgit (import ./gitFull.nix { inherit self super; });
    git = patchgit super.gitAndTools.git;
    gitSVN = patchgit super.gitAndTools.gitSVN;
  }
