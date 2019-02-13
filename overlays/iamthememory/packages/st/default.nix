{ self, super }:
  super.st.override {
    conf = builtins.readFile ./st-0.8.2.h;
    patches = [
      ./patches/st-colorswap-0.8.2.patch
    ];
  }
