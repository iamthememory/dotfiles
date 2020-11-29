# Configure the ZSH sudo plugin, which (un)prefixes sudo to commands when you
# press ESC twice.
{
  inputs,
  ...
}: {
  programs.zsh.plugins = [{
    name = "zsh-sudo";
    src = inputs.zsh-sudo;
    file = "sudo.plugin.zsh";
  }];
}
