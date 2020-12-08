# Neovim completion and linting configuration.
{
  config,
  pkgs,
  ...
}: {
  # Enable COC.
  programs.neovim.coc.enable = true;

  # COC's neovim configuration.
  programs.neovim.coc.config = ''
    " Much of the following is from COC's README.

    " Check if we're in a word or if right before the cursor is whitespace.
    function! s:check_back_space() abort
      let col = col('.') - 1
      return !col || getline('.')[col - 1] =~# '\s'
    endfunction

    " Use tab for completion, snippet expansion, and jumping.
    inoremap <silent><expr> <TAB>
      \ pumvisible() ? coc#_select_confirm() :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump','''])\<CR>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

    " Use shift-tab to move back in te completion list if it's available.
    inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

    " Jump to the definition of a symbol.
    nmap <silent> gd <Plug>(coc-definition)

    " Jump to the type definition of a symbol.
    nmap <silent> gy <Plug>(coc-type-definition)

    " Jump to the implementation for a symbol.
    nmap <silent> gi <Plug>(coc-implementation)

    " Jump to references for a symbol.
    nmap <silent> gr <Plug>(coc-references)

    " Show the documentation for the given symbol.
    function! s:show_documentation()
      if (index(['vim','help'], &filetype) >= 0)
        execute 'h '.expand('<cword>')
      elseif (coc#rpc#ready())
        call CocActionAsync('doHover')
      else
        execute &keywordprg . " " . expand('<cword>')
      endif
    endfunction

    " Show documentation in a preview window.
    nnoremap <silent> K :call <SID>show_documentation()<CR>

    " Highlight the symbol and references when holding the cursor.
    autocmd CursorHold * silent call CocActionAsync('highlight')

    " Format the selected code.
    xmap <leader>f <Plug>(coc-format-selected)
    nmap <leader>f <Plug>(coc-format-selected)

    " Add :Format to format the current buffer.
    command! -nargs=0 Format :call CocAction('format')

    " Add :Fold to fold the current buffer.
    command! -nargs=? Fold :call CocAction('fold', <f-args>)

    " Add :OR to organize the imports of the current buffer.
    command! -nargs=0 OR :call CocAction('runCommand', 'editor.action.organizeImport')
  '';

  # COC settings.
  programs.neovim.coc.settings = {
    # Don't check for updates, since we manage COC extensions through our
    # generation.
    "coc.preferences.extensionUpdateCheck" = "never";

    # Use the quickfix list for locations.
    "coc.preferences.useQuickfixForLocations" = true;

    # Send diagnostics to ALE to display them.
    "diagnostic.displayByAle" = true;

    # Don't save sessions with coc-lists, let obsession manage that.
    "session.saveOnVimLeave" = false;

    # The directory for custom snippets.
    "snippets.userSnippetsDirectory" = "${config.xdg.configHome}/nvim/snippets";

    # Show function signatures with echodoc.
    "suggest.echodocSupport" = true;
  };

  programs.neovim.plugins = with pkgs.vimPlugins; [
    # A plugin to show diagnostics and linter warnings.
    {
      plugin = ale;
      config = ''
        " Disable LSP features, since COC is supplying those to ALE.
        let g:ale_disable_lsp = 1

        " Run fixers on each file save.
        let g:ale_fix_on_save = 1

        " General fixers to use.
        if !exists("g:ale_fixers")
          let g:ale_fixers = {}
        endif
        let g:ale_fixers['*'] = ['remove_trailing_lines', 'trim_whitespace']

        " Run all linters that are available by default.
        let g:ale_linters_explicit = 0
      '';
    }

    # A plugin to view COC lists with fzf.
    coc-fzf

    # Extra lists for COC.
    coc-lists

    # A plugin for snippet completion and expansion with COC.
    {
      plugin = coc-snippets;
      config = ''
        " Go to the next snippet.
        let g:coc_snippet_next = '<tab>'
      '';
    }

    # Enable completion/highlighting from the yank history.
    coc-yank

    # A plugin to show completion function signatures.
    {
      plugin = echodoc;
      config = ''
        let g:echodoc#enable_at_startup = 1
      '';
    }
  ];
}
