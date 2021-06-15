# The configuration for direnv, which can dynamically add environment variables
# for specific directories to, e.g., set up a build environment for a source
# tree without needing a separate nix-shell or similar.
{ ...
}: {
  # Enable direnv.
  programs.direnv.enable = true;

  # Enable integration with any shells that are enabled.
  # NOTE: This won't have an effect unless the relevant shell is enabled too.
  programs.direnv.enableBashIntegration = true;
  programs.direnv.enableFishIntegration = true;
  programs.direnv.enableZshIntegration = true;

  # Enable using nix-direnv, a faster version of direnv's use_nix which can
  # also cache the development shells.
  programs.direnv.nix-direnv.enable = true;

  # Enable flakes support in nix-direnv.
  programs.direnv.nix-direnv.enableFlakes = true;
}
