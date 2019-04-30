{ self, super }:
  with super; super.vim_configurable.override {
    cscopeSupport = true;
    features = "huge";
    ftNixSupport = true;
    guiSupport = "gtk3";
    luaSupport = true;
    multibyteSupport = true;
    nlsSupport = true;
    perlSupport = true;
    pythonSupport = true;
    rubySupport = true;
    tclSupport = true;
    ximSupport = true;

    python = pkgs.python3Full;
  }
