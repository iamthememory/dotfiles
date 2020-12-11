# Shell script configuration.
{
  pkgs,
  ...
}: let
  settings = ''
    " Expands tabs to spaces.
    setlocal expandtab

    " Fold text by indents.
    setlocal foldmethod=indent

    " Set shifts and expanded tabs to two spaces.
    setlocal shiftwidth=2
    setlocal softtabstop=2

    " Treat hard tabs as 8 spaces.
    setlocal tabstop=8

    " Try to wrap text at 80 characters.
    setlocal textwidth=80
  '';
in {
  home.packages = with pkgs; [
    # Add shellcheck for linting shell scripts.
    shellcheck

    # Add shfmt for formatting shell scripts.
    shfmt
  ];

  # Configuration for shell scripts.
  programs.neovim.extraConfig = ''
    " Use bash as the default shell for linting if it can't be read from the
    " shebang.
    let g:ale_sh_shell_default_shell = '${pkgs.stdenv.shell}'

    " Run shfmt on saving.
    " Also make sure g:ale_fixers exists, because home-manager can put these
    " configs in whatever order it likes.
    if !exists("g:ale_fixers")
      let g:ale_fixers = {}
    endif
    let g:ale_fixers['sh'] = ['shfmt']
  '';

  # Buffer settings for shell scripts.
  xdg.configFile."nvim/ftplugin/sh.vim".text = settings;
  xdg.configFile."nvim/ftplugin/zsh.vim".text = settings;
}
