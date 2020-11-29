# The configuration for zsh.
{
  config,
  ...
}: {
  imports = [
    ./directory-utils.nix
  ];

  # Enable zsh.
  programs.zsh.enable = true;

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
    homeDirectory = config.home.homeDirectory;
    dotDir = config.programs.zsh.dotDir;
  in "${homeDirectory}/${dotDir}/.zsh_history";

  # Keep a lot of history.
  programs.zsh.history.save = 1000000;
  programs.zsh.history.size = config.programs.zsh.history.save;

  # Share history between shell sessions.
  programs.zsh.history.share = true;
}
