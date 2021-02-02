# (La)TeX configuration.
{ pkgs
, ...
}:
let
  settings = ''
    " Expands tabs to spaces.
    setlocal expandtab

    " Fold text by syntax.
    setlocal foldmethod=syntax

    " Set shifts and expanded tabs to four spaces.
    setlocal shiftwidth=2
    setlocal softtabstop=2

    " Treat hard tabs as 8 spaces.
    setlocal tabstop=8

    " Try to wrap text at 80 characters.
    setlocal textwidth=80
  '';
in
{
  programs.neovim.extraConfig = ''
    " Assume LaTeX format for TeX files
    let g:tex_flavor='latex'
  '';

  # Buffer settings for (La)TeX and BibTeX.
  xdg.configFile."nvim/ftplugin/bib.vim".text = settings;
  xdg.configFile."nvim/ftplugin/tex.vim".text = settings;
}
