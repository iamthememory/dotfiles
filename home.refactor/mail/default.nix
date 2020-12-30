# Settings for email.
{ config
, lib
, pkgs
, ...
}: {
  imports = [
    # Ensure we have the xdg configuration available.
    ../xdg.nix

    ./mailcap.nix
    ./neomutt.nix
  ];

  # Set the base mail path to the same as the xdg mail directory.
  accounts.email.maildirBasePath = config.xdg.userDirs.extraConfig.XDG_MAIL_DIR;

  # Link ~/.abook to ~/.config/abook for compatibility, since home-manager likes
  # to put abook's config there, and this keeps all the files together.
  home.activation.createAbookConfigDirectoryLink =
    let
      # The path to ~/.abook.
      homeConfig = "${config.home.homeDirectory}/.abook";

      # The path to a ln binary.
      ln = "${pkgs.coreutils}/bin/ln";

      # The path to a realpath binary.
      realpath = "${pkgs.coreutils}/bin/realpath";

      # The path to ~/.config/abook.
      xdgConfig = "${config.xdg.configHome}/abook";
    in
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      if [ ! -e "${homeConfig}" ]
      then
        $VERBOSE_ECHO "Linking ${homeConfig} -> ${xdgConfig}"
        $DRY_RUN_CMD ${ln} -s $VERBOSE_ARG "${xdgConfig}" "${homeConfig}"
      else
        if [ -L "${homeConfig}" ] && [ "$(${realpath} "${homeConfig}")" = "${xdgConfig}" ]
        then
          $VERBOSE_ECHO "Link ${homeConfig} -> ${xdgConfig} already exists"
        else
          errorEcho "Abook config location ${homeConfig} must be a symlink to ${xdgConfig}"
          exit 1
        fi
      fi
    '';

  # Enable abook for storing addresses.
  programs.abook.enable = true;

  # Extra configuration for abook.
  programs.abook.extraConfig =
    let
      browser =
        let
          browserCommand = config.home.sessionVariables.BROWSER or null;
        in
        if browserCommand == null then ""
        else ''
          # Set the browser used by abook.
          set www_command = ${browserCommand}
        '';
    in
    ''
      # Use US-style addresses.
      set address_style = us

      # Save the database on exit.
      set autosave = true

      # Use neomutt as the mutt to use.
      set mutt_command = ${config.home.profileDirectory}/bin/neomutt

      # Keep any fields, even unknown ones.
      set preserve_fields = all

      # Enable colors.
      set use_colors = true

      # The colors to use.
      set color_header_bg = blue
      set color_header_fg = black
      set color_list_header_bg = cyan
      set color_list_header_fg = black

      ${browser}
    '';

  # Add afew for initial notmuch tagging.
  programs.afew.enable = true;

  # Clear the default afew config, which, for example, clears new flags to add
  # inbox tags, which neomutt will probably not like.
  programs.afew.extraConfig = ''
  '';

  # Enable lieer, for syncing GMail via tags rather than folders, which is
  # necessary without token authentication, since lieer is one of the few
  # terminal syncing things that can do the OAUTH2 authentication GMail requires
  # if you're not using an application-specific token.
  programs.lieer.enable = true;

  # Enable mbsync for syncing IMAP mailboxes to local Maildir folders.
  programs.mbsync.enable = true;

  # Enable msmtp as an SMTP client/sendmail.
  programs.msmtp.enable = true;

  # Enable notmuch, for tagging and maintaining a database of all emails.
  programs.notmuch.enable = true;

  # Run afew to add default tags on new messages after adding new messages to
  # the notmuch database.
  programs.notmuch.hooks.postNew =
    "${config.home.profileDirectory}/bin/afew --tag --new";

  # Enable syncing lieer accounts.
  services.lieer.enable = true;

  # Enable syncing mbsync accounts.
  services.mbsync.enable = true;

  # Sync mbsync accounts every 5 minutes.
  services.mbsync.frequency = "*:0/5";

  # A service to update the notmuch database for new messages.
  systemd.user.services."update-notmuch-database" = {
    Unit.Description = "Update the notmuch database for new messages";

    Service.Type = "oneshot";
    Service.ExecStart = "${config.home.profileDirectory}/bin/notmuch new";
    Service.WorkingDirectory = "${config.accounts.email.maildirBasePath}";
  };

  # Run the service to update the notmuch database every two minutes.
  systemd.user.timers."update-notmuch-database" = {
    Unit.Description =
      config.systemd.user.services."update-notmuch-database".Unit.Description;

    Timer.OnCalendar = "*:0/2";
    Timer.RandomizedDelaySec = 30;

    Install.WantedBy = [
      "timers.target"
    ];
  };
}
