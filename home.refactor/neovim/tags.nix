# ctags configuration for neovim.
{
  inputs,
  ...
}: let
  inherit (inputs.lib) mkVimPlugin;

  tagbar = mkVimPlugin {
    pname = "tagbar";
    src = inputs.tagbar;
  };

  vim-gutentags = mkVimPlugin {
    pname = "vim-gutentags";
    src = inputs.vim-gutentags;
  };
in {
  imports = [
    # Ensure we have ctags and its configuration available.
    ../ctags.nix
  ];

  programs.neovim.plugins = [
    # A plugin for showing the tags of a file in a window for navigation.
    tagbar

    # A plugin for smartly (re)generating tag files.
    {
      plugin = vim-gutentags;
      config = ''
        " Put the ctags file at .ctags in the project root to make it a bit
        " less cluttery.
        " Gutentags will add this to (neo)vim's tag locations.
        let g:gutentags_ctags_tagfile = ".ctags"
      '';
    }
  ];
}
