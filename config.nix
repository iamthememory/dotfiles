with import <nixpkgs> {};
  {
    allowUnfree = true;

    android_sdk = {
      accept_license = true;
    };
  }
