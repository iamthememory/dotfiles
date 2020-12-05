# Various utilities for neovim.
{
  inputs,
  pkgs,
  ...
}: let
  inherit (inputs.lib) mkVimPlugin;

  direnv-vim = mkVimPlugin {
    pname = "direnv.vim";
    src = inputs.direnv-vim;
  };

  editorconfig-vim = mkVimPlugin {
    pname = "editorconfig-vim";
    src = inputs.editorconfig-vim;
  };

  fzf = mkVimPlugin {
    pname = "fzf";
    src = inputs.fzf;
  };

  fzf-vim = mkVimPlugin {
    pname = "fzf.vim";
    src = inputs.fzf-vim;
  };

  gundo-vim = mkVimPlugin {
    pname = "gundo.vim";
    src = inputs.gundo-vim;
  };

  recover-vim = mkVimPlugin {
    pname = "Recover.vim";
    src = inputs.recover-vim;
  };

  tabular = mkVimPlugin {
    pname = "tabular";
    src = inputs.tabular;
  };

  vim-abolish = mkVimPlugin {
    pname = "vim-abolish";
    src = inputs.vim-abolish;
  };

  vim-commentary = mkVimPlugin {
    pname = "vim-commentary";
    src = inputs.vim-commentary;
  };

  vim-dispatch = mkVimPlugin {
    pname = "vim-dispatch";
    src = inputs.vim-dispatch;
  };

  vim-easymotion = mkVimPlugin {
    pname = "vim-easymotion";
    src = inputs.vim-easymotion;
  };

  vim-eunuch = mkVimPlugin {
    pname = "vim-eunuch";
    src = inputs.vim-eunuch;
  };

  vim-obsession = mkVimPlugin {
    pname = "vim-obsession";
    src = inputs.vim-obsession;
  };

  vim-repeat = mkVimPlugin {
    pname = "vim-repeat";
    src = inputs.vim-repeat;
  };

  vim-speeddating = mkVimPlugin {
    pname = "vim-speeddating";
    src = inputs.vim-speeddating;
  };

  vim-surround = mkVimPlugin {
    pname = "vim-surround";
    src = inputs.vim-surround;
  };

  vim-unimpaired = mkVimPlugin {
    pname = "vim-unimpaired";
    src = inputs.vim-unimpaired;
  };
in {
  programs.neovim.plugins = [
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
    fzf

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

    # When starting, if there's a swapfile for the file we're trying to edit,
    # give options to compare, recover, etc.
    recover-vim

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
