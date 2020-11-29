# Configure the powerlevel10k theme and prompt.
{
  config,
  inputs,
  pkgs,
  ...
}: let
  # Use the nixpkgs derivation to provide a built and patched gitstatusd in
  # powerlevel10k, but use the revision we pull from the repo as the source to
  # get any newer features.
  # NOTE: We pull from master since it's more likely to match the
  # gitstatusd/powerlevel10k upstream versions more closely.
  p10k = inputs.master.zsh-powerlevel10k.overrideAttrs (oldAttrs: rec {
    name = "${oldAttrs.pname}-${version}";
    version = "${inputs.zsh-powerlevel10k.lastModifiedDate}";
    src = inputs.zsh-powerlevel10k;
  });
in {
  # Add the powerlevel10k plugin to ZSH.
  programs.zsh.plugins = [{
    name = "powerlevel10k";
    src = "${p10k}/share/zsh-powerlevel10k";
    file = "powerlevel10k.zsh-theme";
  }];

  programs.zsh.initExtraBeforeCompInit = let
    username = config.home.username;
    cacheHome = config.xdg.cacheHome;
    p10k-instant = "${cacheHome}/p10k-instant-prompt-${username}.zsh";
  in ''
    # Enable the Powerlevel10k instant prompt.
    # This should be as close to the top of .zshrc as possible, but after
    # anything that's interactive, if applicable.
    # This is more or less taken from what the wizard generates, with paths
    # filled in with home-manager ahead of time rather than when evaluated.
    if [[ -r "${p10k-instant}" ]]
    then
      source "${p10k-instant}"
    fi
  '';

  programs.zsh.initExtra = let
    p10k-config = "${config.home.homeDirectory}/.p10k.zsh";
  in ''
    # Load the powerline10k theme.
    if [ -e "${p10k-config}" ]
    then
      source "${p10k-config}"
    fi
  '';

  # Link the p10k.zsh configuration from here into place.
  home.file.".p10k.zsh".source = ./p10k.zsh;
}
