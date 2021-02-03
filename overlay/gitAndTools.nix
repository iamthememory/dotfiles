{ super
, ...
}:
let
  # Patch the git build to disable a test that fails on ZFS.
  patchGit = pkg: pkg.overrideAttrs (oldAttrs: {
    preInstallCheck = oldAttrs.preInstallCheck + ''
      # This test fails on ZFS.
      disable_test t3910-mac-os-precompose
    '';
  });
in
(super.gitAndTools or { }) // {
  gitFull = patchGit super.gitAndTools.gitFull;
  git = patchGit super.gitAndTools.git;
  gitSVN = patchGit super.gitAndTools.gitSVN;
}
