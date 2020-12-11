{ super
, ...
}: super.gnupg.override {
  # Add support for many optional gpg features.
  # We need to do this in an overlay, since home-manager doesn't let us
  # specify a custom gpg package.

  inherit (super)
    # Enable (de)compression with the bzip2 algorithm.
    bzip2
    # Enable GNUTLS for TLS support.
    gnutls
    # Enable libusb1 for CCID/smartcard support.
    libusb1
    # Enable openldap support for the rare cases where people put their PGP
    # keys on an LDAP server.
    openldap
    # Enable pcsclite for smartcard support.
    pcsclite
    # Enable readline support.
    readline
    # Enable SQLite support (possibly used for TOFU?).
    sqlite
    # Enable (de)compression with zlib.
    zlib;
}
