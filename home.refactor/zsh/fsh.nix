# Configuration for fast-syntax-highlighting, ZSH syntax highlighting in the
# shell.
{
  pkgs,
  ...
}: {
  programs.zsh.initExtra = ''
    # Use the default theme.
    fast-theme -q default
  '';

  # Add fast-syntax-highlighting to ZSH.
  programs.zsh.plugins = [{
    name = "fast-syntax-highlighting";
    src = "${pkgs.zsh-fast-syntax-highlighting}/share/zsh/site-functions";
    file = "fast-syntax-highlighting.plugin.zsh";
  }];
}
