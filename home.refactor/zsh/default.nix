# The configuration for zsh.
{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./zsh-async.nix
    ./powerlevel10k
    ./directory-utils.nix
    ./fsh.nix
    ./omz.nix
    ./sudo.nix
    ./web-search.nix
  ];

  home.packages = with pkgs; [
    # Additional ZSH completions.
    zsh-completions
  ];

  # Enable zsh.
  programs.zsh.enable = true;

  # Enable cd-ing by typing just directories.
  programs.zsh.autocd = true;

  # Put all zsh files in their own directory.
  programs.zsh.dotDir = ".config/zsh";

  # Enable completions for command arguments.
  programs.zsh.enableCompletion = true;

  # Save timestamps in the ZSH history.
  programs.zsh.history.extended = true;

  # Put the ZSH history into the same directory as the configuration.
  # (Keep it .zsh_history because $ZDOTDIR is just treated like an alternate
  # $HOME, not like xdg-style .config/... directories, so ZSH likes things
  # there to still have leading dots.)
  programs.zsh.history.path = let
    inherit (config.home) homeDirectory;
    inherit (config.programs.zsh) dotDir;
  in "${homeDirectory}/${dotDir}/.zsh_history";

  # Keep a lot of history.
  programs.zsh.history.save = 1000000;
  programs.zsh.history.size = config.programs.zsh.history.save;

  # Share history between shell sessions.
  programs.zsh.history.share = true;

  # Early loaded ZSH configuration.
  programs.zsh.initExtraBeforeCompInit = ''
    # Smartly insert text that's pasted into the terminal rather than assuming
    # it's a sequence of characters that's typed in.
    autoload -Uz bracketed-paste-magic
    zle -N bracketed-paste bracketed-paste-magic

    # Smartly quote URLs if needed while typing/pasting them in.
    autoload -Uz url-quote-magic
    zle -N self-insert url-quote-magic
  '';

  # Additional ZSH configuration.
  programs.zsh.initExtra = ''
    # Don't display non-contiguous duplicates while searching with ^R.
    HIST_FIND_NO_DUPS=1

    # Use the more-featured time binary from the profile, rather than the
    # builtin version.
    disable -r time

    # Interactively choose from multiple completions.
    zstyle ':completion::complete:*' use-cache 1

    # Change CTRL-U to clear the line before the cursor, not the entire line.
    # This is more consistent with shells like bash.
    bindkey '^U' backward-kill-line

    # If a directory name is typed, and that isn't a command, cd to the
    # directory.
    setopt autocd

    # Enable spelling correction for commands.
    setopt correct

    # Enable ksh-style extended globbing, e.g. @(foo|bar)
    setopt kshglob

    # Allow comments even though the shell is interactive.
    setopt interactivecomments

    # List jobs in the long format.
    setopt longlistjobs

    # Allow multiple redirects, inserting cat or tee as necessary.
    # E.g., `date >file1 >file2` is equivalent to `date | tee file1 >file2` and
    # `sort <file1 <file2` is equivalent to `cat file1 file2 | sort`.
    setopt multios

    # If a glob has no matches, remove it, rather than leaving it in the
    # command as a literal.
    setopt nullglob

    # pushd alone goes to the home directory, like plain cd.
    setopt pushdtohome
  '';

  # ZSH aliases.
  programs.zsh.shellAliases = {
    # List directories in long form.
    ll = "ls -lh";

    # List all directories (except . and ..) in long form.
    la = "ls -lAh";
  };
}
