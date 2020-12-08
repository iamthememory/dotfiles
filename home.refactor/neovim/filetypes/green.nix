# Green configuration.
{
  ...
}: {
  # Enable detection for files.
  xdg.configFile."nvim/ftdetect/green.vim".text = ''
    au BufRead,BufNewfile *.green set filetype=green syntax=green
  '';

  # Buffer settings for files.
  xdg.configFile."nvim/ftplugin/green.vim".text = ''
    " Enable spelling.
    setlocal spell
    setlocal spelllang=en_us

    " Allow long lines.
    setlocal colorcolumn=0
  '';

  # Syntax for files.
  xdg.configFile."nvim/syntax/green.vim".text = ''
    " >text.
    syntax region greentext start="\v^\>" end="\v.$" contains=greenspoilers
    highlight greentext ctermbg=Black ctermfg=Green guifg=Green

    " Spoilers.
    syntax region spoilers start="\v\[spoiler\]" end="\v\[/spoiler\]"
    highlight spoilers term=reverse cterm=reverse gui=reverse
    syntax region greenspoilers start="\v\[spoiler\]" end="\v\[/spoiler\]" contained
    highlight greenspoilers ctermbg=Green ctermfg=Black
  '';
}
