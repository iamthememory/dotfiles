# HTML, XML, CSS, and Javascript configuration.
{
  pkgs,
  ...
}: let
  settings = ''
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
in {
  # Buffer settings for HTML and XML.
  xdg.configFile."nvim/ftplugin/html.vim".text = settings;
  xdg.configFile."nvim/ftplugin/xml.vim".text = settings;

  # Buffer settings for CSS.
  xdg.configFile."nvim/ftplugin/css.vim".text = settings;

  # Buffer settings for Javascript.
  xdg.configFile."nvim/ftplugin/javascript.vim".text = settings;
}
