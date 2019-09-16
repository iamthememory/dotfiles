{ config, lib, options, ... }:
let
  inherit (import ../channels.nix) unstable;
in
  {
    programs.vim = {
      enable = true;

      plugins = with unstable.vimPlugins; [
        Recover-vim
        ack-vim
        ale
        easymotion
        editorconfig-vim
        fzf-vim
        gundo
        haskell-vim
        nerdcommenter
        nerdtree
        nerdtree-git-plugin
        repeat
        rust-vim
        sleuth
        supertab
        surround
        tabular
        tagbar
        ultisnips
        vim-abolish
        vim-airline
        vim-airline-themes
        vim-colors-solarized
        vim-devicons
        vim-dispatch
        vim-eunuch
        vim-fugitive
        vim-gitgutter
        vim-gutentags
        vim-liquid
        vim-obsession
        vim-polyglot
        vim-sensible
        vim-snippets
        vim-unimpaired
      ];

      extraConfig = ''
        " Don't use compatibility mode
        set nocompatible
        set updatetime=100
        set hidden
        let g:airline#extensions#tabline#enabled = 1
        let g:airline#extensions#gutentags#enabled = 1
        let g:airline_powerline_fonts = 1

        let g:haskell_indent_if = 4
        let g:haskell_indent_case = 4
        let g:haskell_indent_let = 4
        let g:haskell_indent_where = 2
        let g:haskell_indent_do = 4
        let g:haskell_indent_in = 4
        let g:haskell_indent_guard = 2
        let g:cabal_indent_section = 4

        if has('python3')
          let g:gundo_prefer_python3 = 1
        endif

        " vim-rst-tables (reformat reStructuredText tables).
        " Doesn't really work with Python 3.
        "Plugin 'ossobv/vim-rst-tables-py3'

        " VST (reStructuredText).
        "Plugin 'VST'

        " vim-nerdtree-syntax-highlight (extra colors for nerdtree).
        "Plugin 'tiagofumo/vim-nerdtree-syntax-highlight'
        set encoding=UTF-8

        colorscheme solarized

        " Look and feel.

        " If I'm in a terminal, assume the background is dark.
        if !has('gui_running')
          set background=dark
        endif

        " Mark at 80 characters
        set colorcolumn=80

        " Show folds on the left.
        set foldcolumn=2
        set foldlevel=2

        " Show line numbers by default.
        set number

        " Behavior.

        " Case insensitive search if all lowercase.
        set ignorecase
        set smartcase

        " Better file tab completion.
        set wildmode=longest,list,full

        " Formatting options.
        set formatoptions+=tcqjn

        " Keep indents on linebreak.
        set breakindent

        " Show tabs, spaces, etc.
        set list

        " Show highlighting on searchs.
        set hlsearch


        " Try to template from a skeleton.
        autocmd BufNewFile *.* silent! execute '0r $HOME/.vim/templates/skeleton.'.expand("<afile>:e")

        " Default printer options
        set printoptions=paper:letter,duplex:long,top:7pc,bottom:5pc,left:5pc,right:5pc,header:2,number:y,syntax:y

        " Add :Man to open manpages
        runtime! ftplugin/man.vim

        " Save current buffer and make in the background.
        noremap <Leader>m :w<CR>:Make!<CR>

        " Use Doxygen in C/C++ files.
        au BufRead,BufNewFile *.c set filetype=c.doxygen
        au BufRead,BufNewFile *.cpp set filetype=cpp.doxygen
        au BufRead,BufNewFile *.h set filetype=cpp.doxygen
        au BufRead,BufNewFile *.h.in set filetype=cpp.doxygen

        " Assume LaTeX format for TeX files
        let g:tex_flavor='latex'
      '';
    };
  }
