# Mail account functions.
{
  # Make an email account from the given settings.
  mkEmail =
    { address
    , enableSync ? true
    , gpgKey ? null
    , imapHost ? if isGmail then "imap.gmail.com" else null
    , isGmail ? true
    , lieerBoxName ? ""
    , localHostname
    , mailingLists ? [ ]
    , passCommand
    , passLocation
    , primary ? false
    , realName
    , smtpHost ? if isGmail then "smtp.gmail.com" else null
    , useLieer ? false
    , userName ? address
    }:
      assert useLieer -> isGmail;
      assert isGmail ->
        (imapHost == "imap.gmail.com" && smtpHost == "smtp.gmail.com");
      let
        # The sync settings specific to either mbsync or lieer.
        syncSettings =
          if useLieer then {
            # Lieer syncs everything into a single box.
            # These should be overridden later with the virtual mailbox through
            # notmuch that uses tags to figure out what's what.
            folders = {
              inbox = "mail";
              drafts = "mail";
              sent = "mail";
              trash = "mail";
            };

            # Enable lieer for this account.
            lieer.enable = true;

            # Enable syncing for this account.
            lieer.sync.enable = enableSync;

            # Sync every five minutes.
            lieer.sync.frequency = "*:0/5";

            # Timeout after 60 seconds.
            lieer.settings.timeout = 60;
          }
          else {
            # The folder layout.
            folders =
              let
                # The layout for Gmail mbsync accounts.
                mbsyncLayoutGmail = {
                  # Use the GMail drafts folder, which it puts in its own spot.
                  drafts = "[Gmail]/Drafts";

                  # The inbox location.
                  inbox = "Inbox";

                  # Put sent mail into a specific directory for this host.
                  # NOTE: GMail also adds it to [Gmail]/Sent, this just allows
                  # making it easy to see which host I wrote the email on, and
                  # prevents duplicates in [Gmail]/Sent.
                  sent = "[Gmail]/sent.${localHostname}";

                  # Delete mail to the GMail trash folder.
                  trash = "[Gmail]/Trash";
                };

                # The layout for non-Gmail mbsync accounts.
                mbsyncLayout = {
                  # The Drafts folder.
                  drafts = "Drafts";

                  # The inbox location.
                  inbox = "Inbox";

                  # The sent box location.
                  sent = "Sent";

                  # The trash location.
                  trash = "Trash";
                };
              in
              if isGmail then mbsyncLayoutGmail else mbsyncLayout;

            # Enable mbsync for this account.
            mbsync.enable = enableSync;

            # If a folder is added locally or on Gmail, create it on the other
            # side as well and sync it too.
            mbsync.create = "both";

            # GMail really dislikes issuing too many commands and will
            # disconnect us.
            # Set this for GMail and any other servers with similar flood
            # control.
            # Limit the number of pipeline commands to 10.
            mbsync.extraConfig.account.PipelineDepth = 10;

            # Timeout after 60 seconds.
            mbsync.extraConfig.account.Timeout = 60;

            # Store folders exactly as named, allowing subdirectories.
            mbsync.subFolders = "Verbatim";
          };
      in
      {
        # The email address for this account.
        inherit address;

        # Use the appropriate flavoring.
        flavor = if isGmail then "gmail.com" else "plain";

        # If given a GPG key, add it and sign by default.
        gpg =
          if gpgKey == null then null
          else {
            key = gpgKey;
            signByDefault = true;
          };

        # The imap host for GMail.
        imap.host = imapHost;

        # Enable msmtp for sending mail.
        msmtp.enable = true;

        # Enable neomutt for this account.
        neomutt.enable = true;

        # Extra configuration for neomutt.
        neomutt.extraConfig =
          let
            # If we have a gpg key, enable signing and encrypting.
            gpgSettings =
              if gpgKey == null then ''
                # Unset any encryption settings.
                set crypt_replysign = no
                set crypt_replyencrypt = no
                set crypt_replysignencrypted = no
                unset pgp_default_key
              ''
              else ''
                # Sign replies to emails that are signed.
                set crypt_replysign = yes

                # Encrypt replies to emails that are encrypted.
                set crypt_replyencrypt = yes

                # Sign replies to emails that are encrypted as well.
                set crypt_replysignencrypted = yes

                # Set the default PGP key.
                set pgp_default_key = ${gpgKey}
              '';

            # Lieer folder settings.
            # This is needed to set all locations to the virtual mailboxes
            # through notmuch.
            lieerFolders =
              if useLieer then ''
                # Use the virtual mailboxes through notmuch for this account.
                set postponed = "${lieerBoxName}/Drafts"
                set record = "${lieerBoxName}/Sent"
                set spoolfile = "${lieerBoxName}/Inbox"
                set trash = "${lieerBoxName}/Trash"
              ''
              else "";

            # The mailing lists subscribed to for this account.
            subscriptions =
              let
                subscriptionSubscribes =
                  if mailingLists == [ ] then ""
                  else ''
                    # Add mailing lists for this account.
                    subscribe ${builtins.concatStringsSep " " mailingLists}
                  '';
              in
              ''
                # Unset any mailing lists.
                unlists *
              '' + subscriptionSubscribes;
          in
          ''
            ${gpgSettings}

            ${subscriptions}

            ${lieerFolders}
          '';

        # Enable notmuch indexing.
        notmuch.enable = true;

        # Get the password from pass.
        passwordCommand = "${passCommand} show ${passLocation}";

        # Whether this account is the primary account.
        inherit primary;

        # The real name to use for the from address.
        inherit realName;

        # The SMTP host.
        smtp.host = smtpHost;

        # The username to login as.
        inherit userName;
      } // syncSettings;

  # Generate the neomutt extraConfig for the virtual boxes for the given lieer
  # account.
  mkLieerVirtualBoxes =
    { maildirBasePath
    , boxName
    }:
    let
      # Make a single box from the given name and query.
      mkBox = name: query:
        let
          # The name of the virtual mailbox.
          vName = "${boxName}/${name}";

          # The notmuch query.
          nmQuery =
            "notmuch://${maildirBasePath}?query=path:${boxName}/** and ${query}";
        in
        "virtual-mailboxes \"${vName}\" \"${nmQuery}\"";
    in
    ''
      # Add the virtual mailboxes for ${boxName}.
      ${mkBox "Inbox" "tag:inbox"}
      ${mkBox "Drafts" "tag:draft"}
      ${mkBox "Sent" "tag:sent"}
      ${mkBox "Trash" "tag:trash"}
    '';
}
