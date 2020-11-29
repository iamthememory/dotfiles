# Configuration for pazi, a tool to jump to frequently used directories.
{
  pkgs,
  ...
}: let
  paziAliases = {
    # An alias for using pazi with fzf for selecting the directory.
    # NOTE: z is itself an alias to a shell function, so there is no full path.
    zf = "z --pipe=${pkgs.fzf}/bin/fzf";
  };
in {
  # Enable pazi.
  programs.pazi.enable = true;

  # Enable integration with any shells that are enabled.
  # NOTE: This won't have an effect unless the relevant shell is enabled too.
  programs.pazi.enableBashIntegration = true;
  programs.pazi.enableFishIntegration = true;
  programs.pazi.enableZshIntegration = true;

  # Add aliases for pazi using fzf.
  # NOTE: These also won't do anything unless the relevant shell is enabled.
  programs.bash.shellAliases = paziAliases;
  programs.fish.shellAliases = paziAliases;
  programs.zsh.shellAliases = paziAliases;
}
