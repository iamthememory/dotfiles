{
  custpkgs,
  pkgs,
  pkgsets,
  utilities,
}:
with pkgs // custpkgs;
rec {
  home = {
    gui-full = utilities.mkhomeenv "gui-full" pkgsets.gui-full;
  };

  devel = {
    cpp = utilities.mkdevenv {
      name = "devel.cpp";
      devpkgs = with pkgs; [
        autoconf
        automake
        binutils
        ccache
        ccacheWrapper
        cmake
        gdb
        gnumake
        patchelf
      ];
    };
  };
}
