# Go configuration.
{ pkgs
, ...
}: {
  home.packages = with pkgs; [
    # A go LSP.
    gopls
  ];

  programs.neovim.extraLuaConfig = ''
    require 'lspconfig'.gopls.setup(require 'coq'.lsp_ensure_capabilities())
  '';

  programs.neovim.plugins = with pkgs.vimPlugins; [
    #vim-go
  ];

  # Buffer settings for go.
  xdg.configFile."nvim/ftplugin/go.vim".text = ''
    " Use hard tabs.
    setlocal noexpandtab

    " Fold text by indents.
    setlocal foldmethod=indent

    " Set shifts and expanded tabs to four spaces.
    setlocal shiftwidth=4
    setlocal softtabstop=4

    " Treat hard tabs as 4 spaces.
    setlocal tabstop=4

    " Try to wrap text at 80 characters.
    setlocal textwidth=80
  '';
}
