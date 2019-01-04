{ config, lib, options, ... }:
let
  inherit (import ../channels.nix) unstable;
  pkgs = unstable;

  locker = pkgs.writeScript "lock.sh" ''
    #${pkgs.bash}/bin/bash

    export XSECURELOCK_BLANK_DPMS_STATE=suspend
    export XSECURELOCK_BLANK_TIMEOUT=30
    export XSECURELOCK_BURNIN_MITIGATION=100
    export XSECURELOCK_DATETIME_FORMAT="%a %Y-%m-%d %H:%M:%S"
    export XSECURELOCK_FONT="Literation Mono Nerd Font"
    export XSECURELOCK_PARANOID_PASSWORD=1
    export XSECURELOCK_SHOW_DATETIME=1
    export XSECURELOCK_SHOW_HOSTNAME=1
    export XSECURELOCK_USERNAME=1
    export XSECURELOCK_WANT_FIRST_KEYPRESS=1


    exec "${pkgs.xsecurelock}/bin/xsecurelock"
  '';
in
  {
    services.screen-locker.enable = true;
    services.screen-locker.inactiveInterval = 20;
    services.screen-locker.lockCmd = "${locker}";
    services.screen-locker.xssLockExtraOptions = [
      "-l"
    ];
  }
