# Configure settings for nightmare.
{
  config,
  lib,
  options,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ../../base.nix
    ../../git.nix
    ../../gnupg.nix
    ../../pass.nix
    ../../utils
    ../../zsh
    ../../zsh/zsh-auto-notify.nix
  ];

  # Select the default gpg signing subkey.
  programs.gpg.settings.default-key = "0x34915A26CE416A5CDF500247D226B54765D868B7";

  # Use a GUI pinentry.
  services.gpg-agent.pinentryFlavor = "gtk2";

  # Set the GitHub token from pass on login for tools like the GitHub CLI.
  # We need to set this as a session variable since we can't set its config to
  # run a command to get the token, and since the config is linked to the nix
  # store "gh auth login" can't put a token into it.
  home.sessionVariables.GITHUB_TOKEN = let
    tokenPath = "github.com/iamthememory.tokens/nightmare";
    pass = "${config.programs.password-store.package}/bin/pass";
  in "$(${pass} ${tokenPath})";
}
