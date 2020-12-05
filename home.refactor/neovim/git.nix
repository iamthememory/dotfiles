# Git-related configuration for neovim.
{
  config,
  inputs,
  pkgs,
  ...
}: let
  inherit (inputs.lib) mkVimPlugin;

  git-messenger = mkVimPlugin {
    pname = "git-messenger.vim";
    src = inputs.git-messenger;
  };

  gv = mkVimPlugin {
    pname = "gv.vim";
    src = inputs.gv;
  };

  nerdtree-git-plugin = mkVimPlugin {
    pname = "nerdtree-git-plugin";
    src = inputs.nerdtree-git-plugin;
  };

  vim-fugitive = mkVimPlugin {
    pname = "vim-fugitive";
    src = inputs.vim-fugitive;
  };

  vim-gist = mkVimPlugin {
    pname = "vim-gist";
    src = inputs.vim-gist;
  };

  vim-github-dashboard = mkVimPlugin {
    pname = "vim-github-dashboard";
    src = inputs.vim-github-dashboard;
  };

  vim-gitgutter = mkVimPlugin {
    pname = "vim-gitgutter";
    src = inputs.vim-gitgutter;
  };

  vim-rhubarb = mkVimPlugin {
    pname = "vim-rhubarb";
    src = inputs.vim-rhubarb;
  };

  webapi-vim = mkVimPlugin {
    pname = "webapi-vim";
    src = inputs.webapi;
  };
in {
  programs.neovim.extraPackages = with pkgs; [
    # Essentially all of these should have git available.
    # This is probably unnecessary, but doesn't hurt if neovim is invoked via
    # an absolute path from a shell with a PATH not matching the generation's,
    # which more or less only applies to testing neovim configurations without
    # changing generations, or obscure recovery cases, but can't hurt.
    config.programs.git.package

    # Ensure we have curl available.
    # This is probably already in our generation's profile, but it doesn't
    # hurt.
    curlFull

    # Rhubarb needs hub.
    # We probably have this but it never hurts.
    gitAndTools.hub

    # We should have grep available, but it doesn't hurt to make sure.
    gnugrep

    # Make sure we have wget, just in case.
    wget
  ];

  # Git-related plugins.
  programs.neovim.plugins = [
    # A plugin that adds a keymapping and command to show the commit(s) where a
    # line was added or modified.
    git-messenger

    # A Git commit browser built on top of fugitive.
    gv

    # An extension to NERDTree that adds support for showing Git status of
    # files.
    {
      plugin = nerdtree-git-plugin;
      config = ''
        " Use extra glyphs from NerdFonts.
        let g:NERDTreeGitStatusUseNerdFonts = 1

        " When in an untracked directory, show each individual file as
        " untracked as well.
        let g:NERDTreeGitStatusUntrackedFilesMode = 'all'
      '';
    }

    # A plugin providing a lot of git commands in (neo)vim, with ways of
    # viewing, editing, diffing, etc. conveniently.
    vim-fugitive

    # A plugin that allows creating, fetching, opening, etc. gists easily.
    {
      plugin = vim-gist;
      config = ''
        " Allow copying a gist to the clipboard.
        " FIXME: This should probably be set based on whether this generation
        " has X11, wayland, is on MacOS, etc. to the appropriate thing.
        let g:gist_clip_command = '${pkgs.xclip}/bin/xclip -selection clipboard'

        " Detect the gist filetype from the filename.
        let g:gist_detect_filetype = 1

        " List private gists when listing gists.
        let g:gist_show_privates = 1

        " Default gists to private.
        let g:gist_post_private = 1

        " Enable manipulating multiple files in a gist.
        let g:gist_get_multiplefile = 1
      '';
    }

    # A plugin that adds a marker in the sign column to show where lines have
    # been added, modified, or removed, compared to what's currently in Git.
    vim-gitgutter

    # A plugin to look at the GitHub dashboard and activity in (neo)vim.
    {
      plugin = vim-github-dashboard;
      config = let
        git = "${config.programs.git.package}/bin/git";
        getGitHubUser = "${git} config --get github.user";
      in ''
        " Clear/initialize the configuration.
        let g:github_dashboard = {}

        " Set the username from the github.user key in git config, and clear
        " whatever junk we put in there if it fails.
        " There is probably a more elegant way to do this.
        let g:github_dashboard['username'] = trim(system("${getGitHubUser}"))
        if v:shell_error != 0
          unlet g:github_dashboard['username']
        endif

        " Add the GITHUB_TOKEN as the "password" from the environment if it's
        " set.
        if $GITHUB_TOKEN != ""
          let g:github_dashboard['password'] = $GITHUB_TOKEN
        endif

        " Allow outputting emoji.
        let g:github_dashboard['emoji'] = 1
      '';
    }

    # A plugin to allow omni-completion of GitHub issues, URLs, collaborators,
    # etc. in commit messages, allows :Gbrowse to open GitHub URLs, sets :Git
    # to use `hub`, etc.
    # This is an extension to fugitive.
    vim-rhubarb

    # A plugin library that helps with access to web APIs.
    # This is needed by vim-gist.
    webapi-vim
  ];
}
