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

  # A short bit of script to setup colors.
  # This is here because adding it to extraConfig appends it to the neovim
  # config, but it needs to be done before plugins that use colors.
  # Since plugins don't really have a predictable order, we just run it before
  # plugins that might need colors setup.
  setupColors = ''
    " Skip over this if this has already been run.
    if !exists("g:home_manager_color_support_has_been_done")
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

      " Don't run this block again.
      let g:home_manager_color_support_has_been_done = 1
    endif
  '';
in
{
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
        " Ensure colors are setup.
        ${setupColors}

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
        " Ensure colors are setup.
        ${setupColors}

        " Use the default solarized variant.
        colorscheme solarized8
      '';
    }
  ];
}
