# Configuration for taking some basic niceties from oh-my-zsh.
# Copy some basic niceties I don't want to reimplement from oh-my-zsh that I'm
# used to.
# This is mainly everything in the lib/* directory in oh-my-zsh, which is
# apparently always loaded, and which contains tweaks to completion,
# keybindings, etc.
{
  pkgs,
  ...
}: let
  omz-lib = "${pkgs.oh-my-zsh}/share/oh-my-zsh/lib";
in {
  # Load some basic oh-my-zsh niceties early.
  programs.zsh.initExtraBeforeCompInit = ''
    # Load some completion tweaks.
    source "${omz-lib}/completion.zsh"

    # Load history tweaks.
    source "${omz-lib}/history.zsh"

    # Load basic keybindings and keybinding tweaks.
    source "${omz-lib}/key-bindings.zsh"

    # Show the running process as the terminal title.
    source "${omz-lib}/termsupport.zsh"
  '';
}
