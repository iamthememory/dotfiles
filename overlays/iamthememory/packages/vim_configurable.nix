{ self, super }:
  with super; super.vim_configurable.override {
    python = pkgs.python3Full;
  }
