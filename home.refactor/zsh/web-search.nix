# Configure the web-search plugin for ZSH.
{
  inputs,
  ...
}: {
  # Add web search aliases to ZSH.
  programs.zsh.plugins = [{
    name = "web-search";
    src = inputs.zsh-web-search;
    file = "web_search.plugin.zsh";
  }];
}
