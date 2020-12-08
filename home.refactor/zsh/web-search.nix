# Configure the web-search plugin for ZSH.
{
  pkgs,
  ...
}: {
  # Add web search aliases to ZSH.
  programs.zsh.plugins = [{
    name = "web-search";
    src = "${pkgs.oh-my-zsh}/share/oh-my-zsh/plugins/web-search";
    file = "web_search.plugin.zsh";
  }];
}
