# MOOcode configuration.
{ ...
}: {
  # Buffer settings for MOOcode.
  xdg.configFile."nvim/ftplugin/moo.vim".text = ''
    " Expands tabs to spaces.
    setlocal expandtab

    " Fold text by indent.
    setlocal foldmethod=indent

    " Set shifts and expanded tabs to two spaces.
    setlocal shiftwidth=2
    setlocal softtabstop=2

    " Treat hard tabs as 8 spaces.
    setlocal tabstop=8
  '';
}
