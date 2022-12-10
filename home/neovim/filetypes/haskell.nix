# Haskell configuration.
{ pkgs
, ...
}: {
  home.packages = with pkgs; [
    # Add haskell-language-server for its LSP wrapper.
    haskell-language-server
  ];

  # COC settings for haskell-language-server.
  programs.neovim.coc.settings.languageserver.haskell = {
    # Use whatever wrapper is in the PATH.
    command = "haskell-language-server-wrapper";
    args = [ "--lsp" ];
    rootPatterns = [
      "*.cabal"
      "stack.yaml"
      "cabal.project"
      "package.yaml"
      "hie.yaml"
    ];
    filetypes = [
      "haskell"
      "lhaskell"
    ];
  };

  # Buffer settings for Haskell.
  xdg.configFile."nvim/ftplugin/haskell.vim".text = ''
    " Expands tabs to spaces.
    setlocal expandtab

    " Fold text by indents.
    setlocal foldmethod=indent

    " Set shifts and expanded tabs to four spaces.
    setlocal shiftwidth=4
    setlocal softtabstop=4

    " Treat hard tabs as 8 spaces.
    setlocal tabstop=8

    " Try to wrap text at 80 characters.
    setlocal textwidth=80
  '';
}
