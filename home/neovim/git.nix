# Git-related configuration for neovim.
{ config
, pkgs
, ...
}: {
  imports = [
    # Ensure we have our git configuration loaded in this generation.
    ../git.nix
  ];

  home.packages = with pkgs; [
    # Ensure we have xclip available for vim-gist.
    # FIXME: This should probably be based on whether this is X11, wayland,
    # MacOS, etc., much like g:gist_clip_command below.
    xclip
  ];

  # Git-related plugins.
  programs.neovim.plugins = with pkgs.vimPlugins; [
    # A plugin that adds a keymapping and command to show the commit(s) where a
    # line was added or modified.
    git-messenger-vim

    # A Git commit browser built on top of fugitive.
    gv-vim

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
      config =
        let
          xclip = "${config.home.profileDirectory}/bin/xclip";
        in
        ''
          " Allow copying a gist to the clipboard.
          " FIXME: This should probably be set based on whether this generation
          " has X11, wayland, is on MacOS, etc. to the appropriate thing.
          let g:gist_clip_command = '${xclip} -selection clipboard'

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
      config =
        let
          git = "${config.home.profileDirectory}/bin/git";
          getGitHubUser = "${git} config --get github.user";
        in
        ''
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
