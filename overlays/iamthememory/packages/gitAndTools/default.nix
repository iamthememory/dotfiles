{ self, super }:
  (super.gitAndTools or {}) // {
    gitFull = import ./gitFull.nix { inherit self super; };
  }
