" Don't use compatibility mode
set nocompatible

" Turn off filetyping until Vundle is ready.
filetype off


" Add Vundle to the runtime path and initialize it.
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()


" Vundle plugins

" Let Vundle manage itself.
Plugin 'VundleVim/Vundle.vim'

" vim-sensible (reasonable default settings).
Plugin 'tpope/vim-sensible'

" vim-gitgutter (show changed lines from the Git repo).
Plugin 'airblade/vim-gitgutter'

" Recover (diff swapfiles when recovering buffers).
Plugin 'chrisbra/Recover.vim'

" EditorConfig (automatic per-project editor settings).
Plugin 'editorconfig/editorconfig-vim'

" tagbar (ctags browser).
Plugin 'majutsushi/tagbar'
nmap <F8> :TagbarToggle<CR>

" haskell-vim (haskell)
Plugin 'neovimhaskell/haskell-vim'
let g:haskell_indent_if = 4
let g:haskell_indent_case = 4
let g:haskell_indent_let = 4
let g:haskell_indent_where = 2
let g:haskell_indent_do = 4
let g:haskell_indent_in = 4
let g:haskell_indent_guard = 2
let g:cabal_indent_section = 4

" vim-rst-tables (reformat reStructuredText tables).
" Doesn't really work with Python 3.
"Plugin 'ossobv/vim-rst-tables-py3'

" nerdtree (directory browser).
Plugin 'scrooloose/nerdtree'

" vim-polyglot (support for numerous languages).
Plugin 'sheerun/vim-polyglot'

" Dispatch (asynchronous command running).
Plugin 'tpope/vim-dispatch'

" vim-eunuch ("Vim sugar for the UNIX shell commands").
Plugin 'tpope/vim-eunuch'

" Fugitive (git functionality).
Plugin 'tpope/vim-fugitive'

" Obsession (auto-saving sessions).
Plugin 'tpope/vim-obsession'

" VST (reStructuredText).
Plugin 'VST'

" nerdtree-git-plugin (git support for nerdtree).
Plugin 'Xuyuanp/nerdtree-git-plugin'


" All Vundle plugins must be before this line.
call vundle#end()

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

" Statusline.
if has('statusline')
	set laststatus=2
	set statusline=%< " Left align
	set statusline+=%f\  " Filename
	set statusline+=%w " Preview window flag (if applicable)
	set statusline+=%h " Help buffer flag (if applicable)
	set statusline+=%m " Modified flag
	set statusline+=%r " Readonly flag (if applicable)
	set statusline+=%{fugitive#statusline()}\  " Fugitive (current git branch)
	set statusline+=%y\  " File type
	set statusline+=%= "Right align
	set statusline+=%-14.(%l,%c%V%)\ %p%% " Current file position
endif


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

" Local changes.
if filereadable("$HOME/.vimrc.local")
  source "$HOME/.vimrc.local"
endif
