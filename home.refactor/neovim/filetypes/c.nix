# Configuration for C/C++.
{
  pkgs,
  ...
}: let
  settings = ''
    " Fold text by syntax, AKA brackets.
    setlocal foldmethod=syntax

    " Use hard tabs.
    setlocal noexpandtab

    " Shift things by 8 spaces, AKA one hard tab.
    setlocal shiftwidth=8
    setlocal softtabstop=8

    " Treat hard tabs as 8 spaces.
    setlocal tabstop=8

    " Try to wrap at 80 characters.
    setlocal textwidth=80
  '';
in {
  # Extra configuration for C/C++.
  programs.neovim.extraConfig = ''
    " Use Doxygen syntax support for C/C++ files by default.
    au BufRead,BufNewFile *.c set filetype=c.doxygen
    au BufRead,BufNewFile *.cpp set filetype=cpp.doxygen
    au BufRead,BufNewFile *.h set filetype=cpp.doxygen
    au BufRead,BufNewFile *.h.in set filetype=cpp.doxygen
  '';

  # Buffer settings for files.
  xdg.configFile."nvim/ftplugin/c.vim".text = settings;
  xdg.configFile."nvim/ftplugin/c.doxygen.vim".text = settings;
  xdg.configFile."nvim/ftplugin/cpp.vim".text = settings;
  xdg.configFile."nvim/ftplugin/cpp.doxygen.vim".text = settings;
}
