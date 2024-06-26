# Configuration for ctags.
{ pkgs
, ...
}: {
  home.packages = with pkgs; [
    # An actively developed ctags implementation.
    universal-ctags
  ];

  # Default ctags settings.
  xdg.configFile."ctags/default.ctags".text = ''
    # Enable all extra tag entries for each language by default.
    --extras-all=*

    # Enable all fields for each language by default.
    --fields-all=*

    # Ignore anything within an #if 0 block for languages that use a C-like
    # preprocessor.
    --if0=no

    # Enable all kinds of language specific tags by default.
    --kinds-all=*

    # Disable the F-kind, which appears to be related to file information, but
    # which tagbar complains about.
    --kinds-all=-F

    # Follow symbolic links.
    --links=yes

    # Recurse into directories.
    --recurse=yes

    # Sort the tag file by tagname.
    --sort=yes

    # Specify file paths relative to the tags file, unless the files are
    # specified with absolute paths.
    --tag-relative=yes
  '';

  # The files and directories ctags should ignore.
  xdg.configFile."ctags/ignore.ctags".text = ''
    # Don't go into any version control directories.
    --exclude=.git
    --exclude=.hg
    --exclude=.svn

    # Ignore cargo build directories.
    --exclude=target

    # Ignore nix direnv and result directories.
    --exclude=.direnv
    --exclude=result
    --exclude=result-*

    # Ignore generation builds in this repository.
    --exclude=new-generation
    --exclude=new-os-generation

    # Ignore (neo)vim swapfiles and session files.
    --exclude=*.swn
    --exclude=*.swo
    --exclude=*.swp
    --exclude=Session.vim

    # Ignore backup, cache, or temporary files.
    --exclude=*.bak
    --exclude=*.cache
    --exclude=*.tmp
    --exclude=*~

    # Ignore packages, build directories, and distribution directories.
    --exclude=*.bundle
    --exclude=*.bundle.*
    --exclude=*.tar
    --exclude=*.tar.*
    --exclude=*.zip
    --exclude=build
    --exclude=dist

    # Ignore ctags and cscope files.
    --exclude=.ctags
    --exclude=.ctags.*
    --exclude=tags
    --exclude=tags.*
    --exclude=cscope.*
    --exclude=ncscope.*

    # Ignore Python cache files.
    --exclude=*.pyc
    --exclude=__pycache__

    # Ignore node.js modules.
    --exclude=bower_components
    --exclude=node_modules

    # Ignore logs.
    --exclude=*.log
    --exclude=log
  '';
}
