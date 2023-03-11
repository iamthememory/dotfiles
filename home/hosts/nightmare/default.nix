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
    ../../communication/discord.nix
    ../../ctags.nix
    ../../games
    ../../games/ffxiv
    ../../games/steam.nix
    ../../gdb
    ../../git.nix
    ../../gnupg.nix
    ../../gui
    ../../mail
    ../../media
    ../../media/sound/mpd.nix
    ../../media/sound/spotify.nix
    ../../neovim
    ../../pass.nix
    ../../security
    ../../ssh.nix
    ../../utils
    ../../virtualization
    ../../zsh
    ../../zsh/zsh-auto-notify.nix

    ./secrets
  ];

  # Cookiecutter configuration.
  # NOTE: Cookiecutter's YAML parser can only parse a subset of YAML that
  # *looks* like YAML, and isn't JSON compatible, so we need to reformat it to
  # look like more standard YAML.
  home.file.".cookiecutterrc".source =
    let
      # The JSON version of the configuration.
      configJSON = builtins.toFile "cookiecutterrc.json" (builtins.toJSON {
        # The place to put cloned templates.
        cookiecutters_dir = "${config.home.homeDirectory}/.cookiecutters";

        # Template defaults.
        default_context = {
          full_name = "Alexandria Corkwell";
          email = "i.am.the.memory@gmail.com";
          github_username = "iamthememory";
          license = "MIT OR Apache-2.0";
        };

        # The directory to store replay information.
        replay_dir = "${config.home.homeDirectory}/.cookiecutter_replay";
      });

      # Convert/reformat the JSON config to a more YAML-looking file.
      configYAML = pkgs.runCommand "cookiecutterrc.yaml" { } ''
        # Run strictly and die if anything fails.
        set -euo pipefail

        # Reformat using yq.
        "${pkgs.yq}/bin/yq" -y < "${configJSON}" > "$out"
      '';
    in
    configYAML;

  home.packages = with pkgs; [
    # A utility for syncing files over adb.
    adb-sync

    # A tool to help reverse-engineer binaries.
    ghidra

    # xinput, for the touchpad keybindings below.
    xorg.xinput
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

  # Use /data/music for mpd's music.
  services.mpd.musicDirectory = "/data/music";

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

  # Custom i3 workspaces for nightmare.
  # FIXME: Find if there's a way to extend the default workspaces.
  xsession.windowManager.i3.config.assigns = {
    # Workspace for communication programs.
    "1:comm" = [
      # Put Discord here.
      { class = "^discord$"; }
    ];

    # Workspace for system things, such as hacking on system configuration and
    # updating.
    "2:sys" = [ ];

    # Workspace for email.
    "3:mail" = [ ];

    # FFXIV resources.
    "4:ffdoc" = [ ];

    # FFXIV.
    "5:ffxiv" = [
      # Assign FFXIV to this workspace.
      { instance = "^ffxiv(|launcher|_dx11|boot)\\.exe$"; }
    ];

    # Workspace for miscellaneous windows and browser tabs.
    "9:misc" = [ ];

    # Steam.
    "10:steam" = [
      { class = "^Steam$"; }
    ];
  };

  xsession.windowManager.i3.config.keybindings =
    let
      # The i3 modifier key.
      mod = config.xsession.windowManager.i3.config.modifier;

      # The name of the touchpad device.
      touchpadName = "pointer:SynPS/2 Synaptics TouchPad";

      # The path to xinput in the local profile.
      xinput = "${config.home.profileDirectory}/bin/xinput";
    in
    {
      "${mod}+Shift+t" = "exec ${xinput} disable '${touchpadName}'";
      "${mod}+Control+t" = "exec ${xinput} enable '${touchpadName}'";

    };

  # Use 96 as the DPI for anything that reads xresources.
  xresources.properties."Xft.dpi" = 96;
}
