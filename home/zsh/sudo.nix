# Configure the ZSH sudo plugin, which (un)prefixes sudo to commands when you
# press ESC twice.
{ pkgs
, ...
}: {
  programs.zsh.plugins = [{
    name = "zsh-sudo";
    src = "${pkgs.oh-my-zsh}/share/oh-my-zsh/plugins/sudo";
    file = "sudo.plugin.zsh";
  }];
}
