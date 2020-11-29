# The configuration for zsh-async, a library for running ZSH jobs
# asynchronously.
{
  inputs,
  ...
}: {
  # Add zsh-async as a plugin to ZSH.
  programs.zsh.plugins = [{
    name = "zsh-async";
    src = inputs.zsh-async;
    file = "async.plugin.zsh";
  }];
}
