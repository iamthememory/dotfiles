{ self, super }:
  super.gitAndTools.gitFull.override {
    withLibsecret = true;
  }
