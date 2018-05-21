" >greentext
syntax region greentext start="\v^\>" end="\v.$" contains=greenspoilers
highlight greentext ctermbg=Black ctermfg=Green guifg=Green

" Spoilers
syntax region spoilers start="\v\[spoiler\]" end="\v\[/spoiler\]"
highlight spoilers term=reverse cterm=reverse gui=reverse
syntax region greenspoilers start="\v\[spoiler\]" end="\v\[/spoiler\]" contained
highlight greenspoilers ctermbg=Green ctermfg=Black

" Fix SpellLocal being nearly unreadable.
highlight clear SpellLocal
highlight SpellLocal ctermbg=Magenta
