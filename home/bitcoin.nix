# The bitcoin client and its configuration.
{ config
, pkgs
, ...
}: {
  home.packages = with pkgs; [
    # The bitcoin client.
    bitcoin
  ];

  # Start bitcoin on startup.
  xsession.windowManager.i3.config.startup = [
    { command = "${config.home.profileDirectory}/bin/bitcoin-qt"; }
  ];

  # Put bitcoin's GUI on the scratchpad.
  xsession.windowManager.i3.extraConfig = ''
    for_window [class="^Bitcoin-Qt$"] move scratchpad
  '';
}
