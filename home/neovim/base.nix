# Basic configuration for neovim.
{ config
, pkgs
, ...
}: {
  # Basic configuration.
  programs.neovim.extraConfig = ''
    " When wrapping lines, keep new lines at the same indent.
    set breakindent

    " Use two lines for the command-line space at the bottom, so text doesn't
    " get hidden behind the "-- INSERT --" tag or similar.
    set cmdheight=2

    " Mark a line at 80 characters to avoid overly long lines.
    set colorcolumn=80

    " Use UTF-8 internally and for buffers/RPC.
    " This is the default for neovim, but helpful if using this configuration
    " with Vim.
    set encoding=UTF-8

    " Show folds on the left.
    set foldcolumn=2
    set foldlevel=2

    " When doing automatic formatting, do the following:
    " - c: Auto-wrap comments at textwidth, and insert comment leaders.
    " - j: When joining lines, remove unneeded comment leaders.
    " - n: Wrap indented, numbered lists smartly.
    " - q: Format comments with 'gq'.
    " - t: Auto-wrap at textwidth
    set formatoptions+=cjnqt

    " Allow hiding buffers without forcing prompts to save.
    set hidden

    " Highlight all search results.
    set hlsearch

    " If searching for an all-lowercase term, search case-insensitively, but if
    " searching for a term with uppercase, search exactly.
    set ignorecase
    set smartcase

    " Show tabs, trailing spaces, etc. visually.
    set list

    " Don't force compatibility with vi.
    " This is the default for neovim, but helpful if using this configuration
    " with Vim.
    set nocompatible

    " Show line numbers by default.
    set number

    " For maximum compatibility, use bash when running external commands in a
    " shell.
    set shell=${config.home.profileDirectory}/bin/bash

    " Don't show "match x of y" and similar messages at the bottom when doing
    " completions.
    set shortmess+=c

    " Always show the sign column, where plugins such as fugitive and linters
    " place markers to show changed lines, or lines with warnings or errors.
    set signcolumn=yes

    " Write to swap after 100 ms of idle.
    " This *also* controls how long before CursorHold events are fired, so this
    " should also update linter messages, etc. faster when idle.
    set updatetime=100

    " When completing file-names with tab in a command, complete the
    " longest common string, then list all matches, *then* iterate through
    " them.
    set wildmode=longest,list,full

    " Add :Man to open manpages.
    runtime! ftplugin/man.vim
  '';

  # Basic neovim plugins.
  programs.neovim.plugins = with pkgs.vimPlugins; [
    # Ensure bash is available for our shell setting.
    pkgs.bashInteractive

    # A plugin for browsing directories.
    nerdtree

    # Syntax, indent, definitions, and other support for many languages.
    vim-polyglot

    # Sensible default options for (neo)vim.
    vim-sensible
  ];
}
