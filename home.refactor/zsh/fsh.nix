# Configuration for fast-syntax-highlighting, ZSH syntax highlighting in the
# shell.
{
  inputs,
  ...
}: {
  programs.zsh.initExtra = ''
    # Use the default theme.
    fast-theme -q default
  '';

  # Add fast-syntax-highlighting to ZSH.
  programs.zsh.plugins = [{
    name = "fast-syntax-highlighting";
    src = inputs.zsh-fast-syntax-highlighting;
    file = "fast-syntax-highlighting.plugin.zsh";
  }];
}
