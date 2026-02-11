# Various utilities for neovim.
{ pkgs
, ...
}: {
  imports = [
    # Ensure we have utility packages like ack, ag, ripgrep, and fzf available
    # and configured.
    ../utils
  ];

  programs.neovim.plugins = with pkgs.vimPlugins; [
    # Load any project environment from direnv in (neo)vim.
    direnv-vim

    # Load the formatting options for files from .editorconfig files if they
    # exist in a repo.
    {
      plugin = editorconfig-vim;
      config = ''
        " Don't try to mess with things from fugitive by trying to reformat
        " them.
        let g:EditorConfig_exclude_patterns = ['fugitive://.*']
      '';
    }

    # A plugin to add basic fzf fuzzy file finding to (neo)vim.
    fzf-wrapper

    # A number of helpful commands using fzf.
    fzf-vim

    # A plugin to see the undo/redo tree visually.
    {
      plugin = gundo-vim;
      config = ''
        " Use python3 instead of python2.
        let g:gundo_prefer_python3 = 1
      '';
    }

    # A framework for interfacing with tests in neovim.
    {
      plugin = neotest;
      config = ''
        require('neotest').setup ({
          adapters = {
            require('rustaceanvim.neotest')
          }
        })
      '';
      type = "lua";
    }

    # When starting, if there's a swapfile for the file we're trying to edit,
    # give options to compare, recover, etc.
    Recover-vim

    # A plugin to help easily line up text to make tables or similar.
    tabular

    # A plugin for correcting and substituting words across verb forms,
    # plurals, etc.
    vim-abolish

    # A set of keymaps to quickly (un)comment lines or blocks of code.
    vim-commentary

    # Adds commands to build and test asynchronously.
    vim-dispatch

    # A plugin with keymaps to perform motions without, e.g., counting the
    # number of words to move forward.
    vim-easymotion

    # (Neo)vim equivalents of various *nix shell tools.
    vim-eunuch

    # A plugin that adds :Obsess, which creates and manages a session file to
    # rapidly restore all buffers, window layouts, etc.
    vim-obsession

    # A plugin for making writing text as convenient as code.
    {
      plugin = vim-pencil;
      config = ''
        " Wrap lines at 80 characters.
        let g:pencil#textwidth = 80
      '';
    }

    # Add support for repeating plugin maps with . for plugins that support it.
    vim-repeat

    # Support for incrementing or decrementing dates, or replacing a timestamp
    # with the current time.
    vim-speeddating

    # A plugin to add keymaps to change the brackets, quotes, XML/HTML tags,
    # etc. around text easily.
    vim-surround

    # A plugin that adds a number of paired mappings.
    vim-unimpaired
  ];
}
