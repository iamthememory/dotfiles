# Settings for X11 screen-locking utilities.
{ config
, pkgs
, ...
}:
let
  # The locker script to use.
  # Here we set the environment variables for xsecurelock's settings.
  locker = pkgs.writeShellScriptBin "locker.sh" ''
    # Clear out any XSECURELOCK variables from the environment.
    # This has to be done with half of it in a substitution, because pipelines
    # are run in subshells, so a while at the end of a pipeline can't unset
    # variables in the top-level shell.
    while read -r VARIABLENAME
    do
      unset "$VARIABLENAME"
    done < <( ${pkgs.coreutils}/bin/env \
    | ${pkgs.gnugrep}/bin/grep '^XSECURELOCK' \
    | ${pkgs.gnused}/bin/sed 's/=.*//' )

    # Set the screen to suspend mode when blanking.
    # NOTE: From what I can tell, for nearly all LCDs, standby/suspend/off are
    # all the same thing.
    export XSECURELOCK_BLANK_DPMS_STATE=suspend

    # Blank the screen after 30 seconds.
    export XSECURELOCK_BLANK_TIMEOUT=30

    # Move the prompt up to 100 pixels on wakeup to help prevent screen burn-in.
    export XSECURELOCK_BURNIN_MITIGATION=100

    # The date format to show.
    export XSECURELOCK_DATETIME_FORMAT="%a %Y-%m-%d %H:%M:%S"

    # If another window misbehaves, dump info about it to the logs.
    export XSECURELOCK_DEBUG_WINDOW_INFO=1

    # Use the nerdfont-patched Liberation/Literation Mono font.
    export XSECURELOCK_FONT="LiterationMono Nerd Font Mono"

    # Set the passphrase prompt to the current UNIX time on each keypress for
    # feedback.
    export XSECURELOCK_PASSWORD_PROMPT=time

    # Just blank the screen as the screensaver.
    export XSECURELOCK_SAVER=saver_blank

    # Show the date and time on the login prompt.
    export XSECURELOCK_SHOW_DATETIME=1

    # Show the (short) hostname on the login prompt.
    export XSECURELOCK_SHOW_HOSTNAME=1

    # Show the username on the login prompt.
    export XSECURELOCK_USERNAME=1

    # xsecurelock needs sleep, xprop, and xwininfo.
    export PATH="${pkgs.coreutils}/bin:${pkgs.xlibs.xprop}/bin:${pkgs.xlibs.xwininfo}/bin"

    # Exec xsecurelock.
    exec "${pkgs.xsecurelock}/bin/xsecurelock"
  '';
in
{
  home.packages = with pkgs; [
    # Add the caffeine package to the profile to send commands programmatically
    # to the caffeine service.
    caffeine-ng

    # Add the locker script to the profile so long-running things such as
    # xautolock don't end up trying to use older lockers.
    locker
  ];

  # Enable the caffeine daemon/applet for stopping locking when, e.g., watching
  # videos.
  services.caffeine.enable = true;

  # Enable the X11 screen locker.
  services.screen-locker.enable = true;

  # Lock after 20 minutes.
  services.screen-locker.inactiveInterval = 20;

  # Use our locker script for the lock command.
  services.screen-locker.lockCmd =
    "${config.home.profileDirectory}/bin/locker.sh";

  # Extra options for xautolock.
  services.screen-locker.xautolock.extraOptions = [
    # Don't allow running `xautolock -exit` or the like to kill xautolock.
    "-secure"
  ];

  # Extra options for xss-lock.
  services.screen-locker.xss-lock.extraOptions = [
    # Pass the sleep lock file descriptor along to the locker command.
    # This way, when the computer is suspending, the computer will pause
    # suspending until the locker closes it to show that it's locked the screen.
    "--transfer-sleep-lock"
  ];
}
