# Configure settings for nightmare.
{ config
, lib
, options
, pkgs
, inputs
, ...
}: {
  imports = [
    ../../base.nix
    ../../ctags.nix
    ../../gdb
    ../../git.nix
    ../../gnupg
    ../../gui
    ../../mail
    ../../neovim
    ../../pass.nix
    ../../ssh.nix
    ../../utils
    ../../zsh
    ../../zsh/zsh-auto-notify.nix

    ./secrets
  ];

  # Set the GitHub token from pass on login for tools like the GitHub CLI.
  # We need to set this as a session variable since we can't set its config to
  # run a command to get the token, and since the config is linked to the nix
  # store "gh auth login" can't put a token into it.
  home.sessionVariables.GITHUB_TOKEN =
    let
      tokenPath = "github.com/iamthememory.tokens/nightmare";
      pass = "${config.programs.password-store.package}/bin/pass";
    in
    "$(${pass} ${tokenPath})";

  # Rhubarb, the neovim plugin, wants its GitHub token in its own variable.
  home.sessionVariables.RHUBARB_TOKEN = config.home.sessionVariables.GITHUB_TOKEN;

  # Set the default GitHub username for any programs or (neo)vim plugins that
  # expect it.
  programs.git.extraConfig.github.user = "iamthememory";

  # Select the default gpg signing subkey.
  programs.gpg.settings.default-key = "0x34915A26CE416A5CDF500247D226B54765D868B7";

  # Use a GUI pinentry.
  services.gpg-agent.pinentryFlavor = "gtk2";

  # The mountpoints to monitor.
  system.monitor-mounts = {
    # The hard disk ZFS pool.
    rpool = {
      # The root of rpool is mounted at /rpool to make it easy to check the
      # available space.
      mountpoint = "/rpool";

      # The available GiB to warn and alert at.
      warning = 256;
      alert = 128;
    };

    # The SSD ZFS pool.
    spool = {
      # The root of spool is mounted at /spool to make it easy to check the
      # available space.
      mountpoint = "/spool";

      # The available GiB to warn and alert at.
      warning = 192;
      alert = 96;
    };
  };

  # Monitor the NVIDIA GPU.
  system.monitor-nvidia = true;

  # Disable the touchpad by default.
  xsession.initExtra =
    let
      xinput = "${config.home.profileDirectory}/bin/xinput";
    in
    ''
      # Turn off the touchpad.
      ${xinput} disable 'pointer:SynPS/2 Synaptics TouchPad'
    '';

  # Use 96 as the DPI for anything that reads xresources.
  xresources.properties."Xft.dpi" = 96;
}
