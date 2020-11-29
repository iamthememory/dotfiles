# Configuration for zsh-auto-notify, which shows notifications when
# long-running commands finally finish.
# NOTE: This isn't included by zsh/default.nix because it assumes there's a
# GUI.
# Include it on hosts which have a GUI since I don't know a good way of passing
# a "hasGui" flag along for hosts.
{
  inputs,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    # zsh-auto-notify needs notify-send.
    libnotify
  ];

  programs.zsh.initExtra = ''
    # Notify for commands running longer than 30 seconds.
    AUTO_NOTIFY_THRESHOLD=30

    # Expire notifications after 10 seconds.
    AUTO_NOTIFY_EXPIRE_TIME=10000
  '';

  # Add zsh-auto-notify to ZSH.
  programs.zsh.plugins = [{
    name = "zsh-auto-notify";
    src = inputs.zsh-auto-notify;
    file = "auto-notify.plugin.zsh";
  }];
}
