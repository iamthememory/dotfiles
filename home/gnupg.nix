# The configuration for gpg and gpg-agent.
{ config
, lib
, pkgs
, ...
}: {
  # The configuration for dirmngr.
  home.file.".gnupg/dirmngr.conf".text = ''
    # Use the same keyserver we configured for gpg.
    keyserver ${config.programs.gpg.settings.keyserver}
  '';

  # Enable gpg.
  programs.gpg.enable = true;

  programs.gpg.settings =
    let
      # Only use AES ciphers, and prefer them in order of strength.
      cipher-prefs = "AES256 AES192 AES";

      # Prefer common compression algorithms over ZIP, and any compression
      # over nothing.
      compress-prefs = "ZLIB BZIP2 ZIP Uncompressed";

      # Only use a SHA-2 digest, and prefer them in order of strength.
      digest-prefs = "SHA512 SHA384 SHA256";
    in
    {
      # Use ASCII armored output by default, rather than binary, to make the
      # resulting file safe for transmission methods that don't like non-text.
      armor = true;

      # The order to lookup a key from if encrypting to an email address and
      # no key for that address is in the keyring.
      auto-key-locate = "local keyserver dane cert pka wkd ldap";

      # Always sign other keys with SHA-512.
      cert-digest-algo = "SHA512";

      # Use UTF-8 as the default character set.
      charset = "utf-8";

      # Set the default preferences for new keys to the same settings we use
      # here.
      default-preference-list = "${digest-prefs} ${cipher-prefs} ${compress-prefs}";

      # Show key IDs as the long 16-character ID, prefixed with 0x.
      keyid-format = "0xlong";

      # Use the ubuntu keyserver.
      keyserver = "hkps://keyserver.ubuntu.com";

      # Fetch keys automatically when needed to verify signatures.
      keyserver-options = "auto-key-retrieve";

      # Show additional info when listing keys.
      list-options = "show-uid-validity show-sig-expire";

      # Configure cipher, compression, and digest preferences.
      personal-cipher-preferences = "${cipher-prefs}";
      personal-compress-preferences = "${compress-prefs}";
      personal-digest-preferences = "${digest-prefs}";

      # Ensure subkeys have a signature on the keys they claim to belong to.
      # This prevents someone adding a public subkey to their own key and
      # claiming signatures from the original subkey are from their key.
      require-cross-certification = true;

      # Include the full fingerprint of the signing (sub)key when making
      # signatures as an additional notation.
      sig-notation = "issuer-fpr@notations.openpgp.fifthhorseman.net=%g";

      # Use gpg-agent.
      use-agent = true;

      # Show additional info when verifying signatures.
      verify-options = "show-notations show-policy-urls show-uid-validity";

      # Show key fingerprints.
      with-fingerprint = true;
    };

  # Enable the gpg-agent.
  services.gpg-agent.enable = true;

  # By default, cache keys for a few hours after their last use.
  services.gpg-agent.defaultCacheTtl = 4 * 3600;

  # If in a GUI, grab the keyboard and mouse when asking for a key
  # passphrase.
  services.gpg-agent.grabKeyboardAndMouse = true;

  # Cache keys for a maximum of 12 hours, after which it'll be removed, even
  # if recently used, to force asking for the passphrase again.
  services.gpg-agent.maxCacheTtl = 43200;

  # Set the default pinentry to curses.
  # NOTE: This should be overridden for hosts with GUIs.
  # NOTE: The gnome pinentry doesn't like to work on non-GNOME desktops.
  # The solution is to either keep starting gcr, or shove it into dbus
  # packages (for the host system?), or, easier, just use the gtk2 or qt
  # flavors.
  services.gpg-agent.pinentry.package = lib.mkDefault pkgs.pinentry-curses;
}
