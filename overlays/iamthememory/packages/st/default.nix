{ self, super }:
  super.st.override {
    conf = builtins.readFile ./st-0.8.1.h;
    patches = [
      ./patches/st-colorswap-0.8.1.patch
    ];
  }
