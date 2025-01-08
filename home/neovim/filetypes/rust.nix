# Rust configuration.
{ config
, pkgs
, ...
}: {
  imports = [
    ../../utils/rust.nix
  ];

  # Configuration for Rust.
  programs.neovim.extraConfig = ''
    " Run rustfmt on saving.
    " Also make sure g:ale_fixers exists, because home-manager can put these
    " configs in whatever order it likes.
    if !exists("g:ale_fixers")
      let g:ale_fixers = {}
    endif
    let g:ale_fixers['rust'] = ['rustfmt']


    " Run cargo check/clippy on all targets, including examples, tests, etc.
    " when linting.
    let g:ale_rust_cargo_check_all_targets = 1

    " Use clippy for linting.
    let g:ale_rust_cargo_use_clippy = 1

    " Disable default style to allow setting textwidth to 80.
    let g:rust_recommended_style = 0

    " If it's not set by the project via direnv, set Rust's sources to one from
    " nixpkgs.
    if empty($RUST_SRC_PATH)
      let $RUST_SRC_PATH = '${pkgs.rustPlatform.rustLibSrc}'
    endif
  '';

  programs.neovim.plugins = with pkgs.vimPlugins;
    let
      rustaceanvim-patched = pkgs.neovimUtils.buildNeovimPlugin {
        luaAttr = pkgs.neovim-unwrapped.lua.pkgs.rustaceanvim.overrideAttrs (final: prev: {
          patches = [
            ./rustacean-coq.patch
          ];
        });
        nvimRequireCheck = "rustaceanvim";
      };
    in
    [
      rustaceanvim-patched
    ];

  # Buffer settings for Rust.
  xdg.configFile."nvim/ftplugin/rust.vim".text = ''
    " Expands tabs to spaces.
    setlocal expandtab

    " Fold text by indent.
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
