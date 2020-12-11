# Rust configuration.
{ inputs
, ...
}:
let
  # FIXME: Remove this and use unstable when
  # f77eb9bb4d5d9ff34c6b1c18274e50d0bdddb652 lands in unstable.
  # We use master to ensure we have the changes to handle the Rust 1.47.0
  # reorganization of rust's sources.
  pkgs = inputs.master;

  rust-src = pkgs.rustPlatform.rustLibSrc;
in
{
  home.packages = with pkgs; [
    # Add cargo and rustc for building Rust.
    cargo
    rustc

    # Add clippy for basic linting.
    clippy

    # Add rust-analyzer, the newer, more modular LSP for Rust.
    # NOTE: This is wrapped to add RUST_SRC_PATH if not set.
    # If we have RUST_SRC_PATH set, it'll use that instead.
    rust-analyzer

    # Add rustfmt for formatting Rust code.
    rustfmt
  ];

  # COC settings.
  programs.neovim.coc.settings = {
    # Show document links when hovering.
    "rust-analyzer.hoverActions.linksInHover" = true;

    # The path to rust-analyzer.
    # If not specified, coc-rust-analyzer assumes it needs to download it from
    # a GitHub release.
    "rust-analyzer.serverPath" = "${pkgs.rust-analyzer}/bin/rust-analyzer";
  };

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
      let $RUST_SRC_PATH = '${rust-src}'
    endif
  '';

  programs.neovim.plugins = with pkgs.vimPlugins; [
    # A plugin to add rust-analyzer's LSP support to COC.
    coc-rust-analyzer
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

  # Rustfmt settings.
  xdg.configFile."rustfmt/rustfmt.toml".source =
    let
      toTOML = (pkgs.formats.toml { }).generate;
    in
    toTOML "rustfmt.toml" {
      # Use the 2018 edition of Rust by default.
      edition = "2018";

      # When splitting imports like `use foo::{x, y, z}`, across multiple lines,
      # enforce one thing per line.
      # E.g., format to
      #   use foo:{
      #     long_identifier,
      #     another_identifier,
      #     yet_another,
      #   }
      # rather than
      #   use foo:{
      #     long_identifier, another_identifier,
      #     yet_another,
      #   }
      imports_layout = "HorizontalVertical";

      # Wrap lines at 80 characters.
      max_width = 80;
    };
}
