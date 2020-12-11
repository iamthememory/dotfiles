# Vimscript configuration.
{ pkgs
, ...
}: {
  # Buffer settings for vimscript.
  xdg.configFile."nvim/ftplugin/vim.vim".text = ''
    " Expands tabs to spaces.
    setlocal expandtab

    " Fold text by syntax.
    setlocal foldmethod=syntax

    " Set shifts and expanded tabs to two spaces.
    setlocal shiftwidth=2
    setlocal softtabstop=2

    " Treat hard tabs as 8 spaces.
    setlocal tabstop=8

    " Try to wrap text at 80 characters.
    setlocal textwidth=80
  '';
}
