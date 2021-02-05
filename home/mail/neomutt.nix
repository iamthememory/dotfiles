# Settings for neomutt.
{ config
, inputs
, lib
, pkgs
, ...
}:
let
  # The location of the profile's bin.
  profileBin = "${config.home.profileDirectory}/bin";
in
{
  # Extra packages to install.
  home.packages = with pkgs; [
    # A utility for extracting URLs from text.
    extract_url
  ];

  # Enable neomutt.
  programs.neomutt.enable = true;

  # The keybindings in neomutt.
  programs.neomutt.binds =
    let
      # Make a keybinding from the given values.
      mkBind = m: k: a: {
        action = a;
        key = k;
        map = m;
      };

      # Make bindings for each of the modes given.
      # This is needed since home-manager doesn't allow us to specify multiple
      # modes for a single binding like `index,pager` like (neo)mutt does.
      repBind = ms: k: a: map (m: mkBind m k a) ms;
    in
    [
    ] ++ (repBind [ "index" "pager" ] "R" "group-reply")
    ++ (repBind [ "index" "pager" ] "\\cK" "sidebar-prev")
    ++ (repBind [ "index" "pager" ] "\\cJ" "sidebar-next")
    ++ (repBind [ "index" "pager" ] "\\cO" "sidebar-open")
    ++ (repBind [ "index" "pager" ] "Z" "view-raw-message");

  # Check for new mail every two minutes.
  programs.neomutt.checkStatsInterval = 120;

  # The editor to use.
  programs.neomutt.editor =
    let
      # Get the default editor from our session variables.
      editorBase = config.home.sessionVariables.EDITOR or "$EDITOR";

      # Extra options to set for vi/vim/neovim for editing mail.
      vimOptions = "-c 'set syntax=mail ft=mail enc=utf-8 spell spelllang=en'";

      inherit (lib) hasSuffix;

      # Check if the given editor is probably vim or neovim.
      isVim = e:
        (hasSuffix "/vi" e)
        || (hasSuffix "/vim" e)
        || (hasSuffix "/nvim" e);

      # Add the Vim options to the editor if it looks like (neo)vim.
      editor =
        if isVim editorBase then "${editorBase} ${vimOptions}"
        else "${editorBase}";
    in
    editor;

  # Additional neomutt configuration.
  programs.neomutt.extraConfig =
    let
      # Use the solarized dark theme.
      colorFile =
        "${inputs.mutt-colors-solarized}/mutt-colors-solarized-dark-256.muttrc";

      # A script to find all mailboxes and make mutt entries for them
      # dynamically.
      findAllMailboxes =
        let
          # A script to take the paths to mail directories and turn them into
          # mailbox-name mailbox-path pairs for mutt.
          mkMailboxDescription = pkgs.writeScript "mailbox-description.pl" ''
            #!${pkgs.perl}/bin/perl

            BEGIN {
              $basepath = q{${config.accounts.email.maildirBasePath}/}
            }

            while (<>) {
              chomp;

              $boxname = s/\Q$basepath\E//r;
              print "\"$boxname\" ";
              print "\"$_\" ";
            }
          '';
        in
        pkgs.writeScript "find-mailboxes.sh" ''
          #!${pkgs.stdenv.shell}

          ${pkgs.findutils}/bin/find \
                "${config.accounts.email.maildirBasePath}" \
                -type d \
                \( -name cur -o -name new \) \
                \( \! -empty \) \
                -printf '%h\n' \
            | ${pkgs.coreutils}/bin/sort \
            | ${pkgs.coreutils}/bin/uniq \
            | ${mkMailboxDescription}
        '';
    in
    ''
      # Mark anything marked by SpamAssassin as probably spam.
      spam "X-Spam-Score: ([0-9\\.]+).*" "SA: %1"

      # Only show the basic mail headers.
      ignore *
      unignore From To Cc Bcc Date Subject

      # Show headers in the following order.
      unhdr_order *
      hdr_order From: To: Cc: Bcc: Date: Subject:

      # Load solarized colors.
      source "${colorFile}"

      # Find all mailboxes dynamically.
      named-mailboxes `${findAllMailboxes}`
    '';

  # Macros for neomutt.
  programs.neomutt.macros =
    let
      # A convenience function to make a macro from the given arguments.
      mkMacro = m: k: a: {
        action = a;
        key = k;
        map = m;
      };

      # Make a macro for each of the given modes.
      # This is needed since home-manager doesn't allow us to specify multiple
      # modes for a single macro like `index,pager` like (neo)mutt does.
      repMacro = ms: k: a: map (m: mkMacro m k a) ms;
    in
    [
      # Toggle the sidebar's visibility and refresh/redraw the screen.
      (mkMacro "index" "B" "<enter-command>toggle sidebar_visible<enter><refresh>")
      (mkMacro "pager" "B" "<enter-command>toggle sidebar_visible<enter><redraw-screen>")

      # Show the URLs in the current message.
      (mkMacro "pager" ",e" "<pipe-message>${profileBin}/extract_url<return>")
    ] ++
    # Add the from address to abook.
    (repMacro [ "index" "pager" ] "A" "<pipe-message>${profileBin}/abook --add-email<return>");

  # Neomutt settings.
  programs.neomutt.settings = {
    # If the given mail doesn't have an explicit charset, assume an old,
    # Windows-y compatible charset as fallback.
    assumed_charset = "iso-8859-1";

    # Use gpgme for cryptography.
    crypt_use_gpgme = "yes";

    # Use PKA to find keys via DNS records and possibly check whether an email
    # address is controlled by who it says it is.
    crypt_use_pka = "yes";

    # Always try to verify signatures.
    crypt_verify_sig = "yes";

    # Ask to purge messages marked for delete when closing/syncing a box, with
    # the default to do so.
    delete = "ask-yes";

    # When editing outgoing mail, allow editing the headers too.
    edit_headers = "yes";

    # The format to use for subjects when forwarding messages.
    forward_format = "\"Fwd: %s\"";

    # Save 10_000 lines of string buffer history per category.
    history = "10000";

    # Save history to a file in neomutt's directory.
    history_file = "${config.xdg.configHome}/neomutt/history";

    # When connecting via IMAP, add all subscribed folders from the server.
    imap_check_subscribed = "yes";

    # Keep IMAP connections alive with a keepalive every 5 minutes.
    imap_keepalive = "300";

    # Use a smaller IMAP pipeline to play nice with servers like GMail.
    imap_pipeline_depth = "5";

    # Check for new mail every minute.
    mail_check = "60";

    # The path to the mailcap file.
    mailcap_path = "${config.home.homeDirectory}/.mailcap";

    # Use Maildir-style mailboxes.
    mbox_type = "Maildir";

    # Scroll menus and such by a single line, rather than a whole page.
    menu_scroll = "yes";

    # Show five lines of context when moving between pages in the pager.
    pager_context = "5";

    # The format for the pager status line.
    pager_format = "\" %C - %[%H:%M] %.20v, %s%* %?H? [%H] ?\"";

    # When in the mail pager, show 10 lines of the index above the current
    # message.
    pager_index_lines = "10";

    # Don't move to the next message when reaching the bottom of a message.
    pager_stop = "yes";

    # Query addresses from abook.
    query_command = "\"${profileBin}/abook --mutt-query %s\"";

    # Reply to mail using the same address the original was sent to.
    reverse_name = "yes";

    # Send all mail as UTF-8.
    send_charset = "utf-8";

    # Sort the mailboxes in the sidebar by mailbox path.
    sidebar_sort_method = "path";

    # Sort by last message date if messages are in the same thread.
    sort_aux = "last-date-received";

    # Separate matching spam headers with this separator.
    spam_separator = ", ";

    # Only group messages as a thread by the In-Reply-To or References headers,
    # rather than matching subject names.
    strict_threads = "yes";

    # Search messages against their decoded contents.
    thorough_search = "yes";

    # Pad blank lines at the bottom of the screen with tildes.
    tilde = "yes";
  };

  # Enable the sidebar.
  programs.neomutt.sidebar.enable = true;

  # The format to use for the sidebar.
  programs.neomutt.sidebar.format = "%D%?F? [%F]?%* %?N?%N/?%S";

  # Show the full mailbox paths in the sidebar.
  programs.neomutt.sidebar.shortPath = false;

  # Make the sidebar 56 characters wide.
  programs.neomutt.sidebar.width = 56;

  # Sort messages by thread.
  programs.neomutt.sort = "threads";

  # Use vim-like keybindings in neomutt.
  programs.neomutt.vimKeys = true;
}
