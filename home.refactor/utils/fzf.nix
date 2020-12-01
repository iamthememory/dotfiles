# Configuration for fzf, a fuzzy finder.
{
  ...
}: {
  # Enable fzf.
  programs.fzf.enable = true;

  # Enable integration with shells.
  # NOTE: These will only do anything if the relevant shell is also enabled.
  programs.fzf.enableBashIntegration = true;
  programs.fzf.enableFishIntegration = true;
  programs.fzf.enableZshIntegration = true;
}
