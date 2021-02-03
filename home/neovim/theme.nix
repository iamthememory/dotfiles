# Theme-related configuration for neovim.
{ inputs
, pkgs
, ...
}:
let
  inherit (inputs.lib) mkVimPlugin;
  inherit (inputs.scripts) truecolor-support;

  # FIXME: Replace this if it gets added to nixpkgs.
  vim-solarized8 = mkVimPlugin {
    pname = "vim-solarized8";
    src = inputs.vim-solarized8;
  };
in
{
  # Theme-related configuration.
  programs.neovim.extraConfig = ''
    " If we're in a terminal, assume we have a dark background, because we
    " almost certainly do, and I don't know of a way to detect it.
    " This also makes vim-solarized8 choose a solarized dark theme.
    if !has('gui_running')
      set background=dark
    endif

    " Check if we have truecolor, and if so, enable all neovim colors.
    if trim(system("${truecolor-support}")) == "yes"
      set termguicolors
    endif
  '';

  # Extra things to add to the PATH when running neovim.
  programs.neovim.extraPackages = with pkgs; [
    # Airline needs msgfmt for .po support.
    gettext
  ];

  # Theme-related plugins.
  programs.neovim.plugins = with pkgs.vimPlugins; [
    # A plugin for a fancy, featureful statusline.
    {
      plugin = vim-airline;
      config = ''
        " Enable powerline font symbols.
        " These are also included in nerd fonts.
        let g:airline_powerline_fonts=1

        " NOTE: Airline *should* enable support for any plugins it finds.
        " Configure the airline options for them (if any) where the plugin is
        " configured.
      '';
    }

    # A plugin with themes for airline.
    {
      plugin = vim-airline-themes;
      config = ''
        " Use the solarized theme.
        let g:airline_theme='solarized'

        " If we're using a dark background, set the airline theme's background
        " to dark as well.
        if &background == "dark"
          let g:airline_solarized_bg='dark'
        endif
      '';
    }

    # A plugin that adds icons to other plugins.
    vim-devicons

    # A solarized colorscheme that supports truecolor.
    {
      plugin = vim-solarized8;
      config = ''
        " Use the default solarized variant.
        colorscheme solarized8
      '';
    }
  ];
}
