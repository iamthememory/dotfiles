# Mail configuration.
{
  pkgs,
  ...
}: {
  # Buffer settings for mail.
  xdg.configFile."nvim/ftplugin/mail.vim".text = ''
    " Expands tabs to spaces.
    setlocal expandtab

    " Fold text by indents.
    setlocal foldmethod=indent

    " Set shifts and expanded tabs to four spaces.
    setlocal shiftwidth=2
    setlocal softtabstop=2

    " Treat hard tabs as 8 spaces.
    setlocal tabstop=8
  '';
}
