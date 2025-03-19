# Nix configuration.
{ pkgs
, ...
}: {
  home.packages = with pkgs; [
    # An LSP for nix.
    nil

    # A sensible formatter for nix code.
    nixpkgs-fmt
  ];

  # Configuration for nix.
  programs.neovim.extraConfig = ''
    " Run nixpkgs-fmt on saving.
    " Also make sure g:ale_fixers exists, because home-manager can put these
    " configs in whatever order it likes.
    if !exists("g:ale_fixers")
      let g:ale_fixers = {}
    endif
    let g:ale_fixers['nix'] = ['nixpkgs-fmt']
  '';

  programs.neovim.extraLuaConfig = ''
    require("lspconfig").nil_ls.setup(require("coq").lsp_ensure_capabilities())
  '';

  # Buffer settings for nix.
  xdg.configFile."nvim/ftplugin/nix.vim".text = ''
    " Expands tabs to spaces.
    setlocal expandtab

    " Fold text by treesitter.
    setlocal foldmethod=expr
    setlocal foldexpr=v:lua.vim.treesitter.foldexpr()

    " Set shifts and expanded tabs to two spaces.
    setlocal shiftwidth=2
    setlocal softtabstop=2

    " Treat hard tabs as 8 spaces.
    setlocal tabstop=8

    " Try to wrap text at 80 characters.
    setlocal textwidth=80
  '';
}
