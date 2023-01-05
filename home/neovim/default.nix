# The configuration for neovim.
{ config
, ...
}:
let
  # The full path to the current neovim.
  neovim = "${config.home.profileDirectory}/bin/nvim";
in
{
  imports = [
    ./base.nix
    ./codesmarts.nix
    ./filetypes
    ./git.nix
    ./tags.nix
    ./theme.nix
    ./utils.nix
  ];

  # Add shell aliases for various vim modes.
  home.shellAliases = {
    # Compatibility aliases for the basic vim commands.
    ex = "${neovim} -e";
    vi = "${neovim}";
    view = "${neovim} -R";
    vim = "${neovim}";
    vimdiff = "${neovim} -d";

    # Compatibility aliases for the restricted-mode vim commands.
    rview = "${neovim} -Z -R";
    rvim = "${neovim} -Z";

    # Aliases for modes that nvim doesn't provide symlinks for like vim.
    nex = "${neovim} -e";
    nrview = "${neovim} -Z -R";
    nrvim = "${neovim} -Z";
    nvi = "${neovim}";
    nview = "${neovim} -R";
    nvimdiff = "${neovim} -d";
    rnview = "${neovim} -Z -R";
    rnvim = "${neovim} -Z";
  };

  # Use neovim for resolving git merges.
  programs.git.extraConfig.merge.tool = "nvimdiff3";
  programs.git.extraConfig.mergetool.nvim3diff.cmd =
    let
      cmd = "${neovim} -f -c \\\"Gdiff\\\" \\\"$MERGED\\\"";
    in
    cmd;

  # Enable neovim.
  programs.neovim.enable = true;

  # Use neovim as the default editor.
  programs.neovim.defaultEditor = true;

  # Enable Node support.
  programs.neovim.withNodeJs = true;

  # Enable Python support.
  programs.neovim.withPython3 = true;

  # Enable Ruby support.
  programs.neovim.withRuby = true;
}
