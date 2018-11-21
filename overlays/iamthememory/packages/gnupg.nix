{ self, super }:
  super.gnupg.override {
    inherit (super) pinentry adns gnutls libusb openldap readline zlib bzip2;
    guiSupport = true;
  }
