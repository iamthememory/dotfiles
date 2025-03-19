# Python configuration.
{ pkgs
, ...
}: {
  # Buffer settings for python.
  xdg.configFile."nvim/ftplugin/python.vim".text = ''
    " Expands tabs to spaces.
    setlocal expandtab

    " Fold text by treesitter.
    setlocal foldmethod=expr
    setlocal foldexpr=v:lua.vim.treesitter.foldexpr()

    " Set shifts and expanded tabs to four spaces.
    setlocal shiftwidth=4
    setlocal softtabstop=4

    " Treat hard tabs as 8 spaces.
    setlocal tabstop=8

    " Try to wrap text at 80 characters.
    setlocal textwidth=80
  '';
}
