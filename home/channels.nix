let
  import-channel = c: (
    import (
      builtins.fetchTarball
      "https://nixos.org/channels/nixos-${c}/nixexprs.tar.xz"
    )
  ) {};

  import-branch = b: (
    import (
      builtins.fetchGit {
        url = "https://github.com/nixos/nixpkgs.git";
        ref = b;
      }
    )
  ) {};
in
rec {
  aardvark     = import-channel "13.10";
  baboon       = import-channel "14.04";
  caterpillar  = import-channel "14.12";
  dingo        = import-channel "15.09";
  emu          = import-channel "16.03";
  flounder     = import-channel "16.09";
  gorilla      = import-channel "17.03";
  hummingbird  = import-channel "17.09";
  impala       = import-channel "18.03";
  jellyfish    = import-channel "18.09";

  stable       = jellyfish;
  unstable     = import-channel "unstable";

  master       = import-branch  "master";
  staging      = import-branch  "staging";
  staging-next = import-branch  "staging-next";
}
