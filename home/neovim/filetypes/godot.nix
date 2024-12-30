# Godot configuration.
{ pkgs
, ...
}: {
  programs.neovim.plugins = with pkgs.vimPlugins; [
    vim-godot
  ];

  # Buffer settings for go.
  xdg.configFile."nvim/ftplugin/godot.vim".text = ''
    " Use hard tabs.
    setlocal noexpandtab

    " Fold text by indents.
    setlocal foldmethod=expr

    " Set shifts and expanded tabs to four spaces.
    setlocal shiftwidth=4
    setlocal softtabstop=4

    " Treat hard tabs as 4 spaces.
    setlocal tabstop=4

    " Try to wrap text at 80 characters.
    setlocal textwidth=80
  '';
}
