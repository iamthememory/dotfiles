{ config, lib, options, ... }:
let
  inherit (import ../channels.nix) unstable;
in
  {
    home.packages = with unstable; [
      universal-ctags
    ];

    home.file = {
      ".ctags.d/default.ctags" = {
        text = ''
          --exclude=.git

          --extras-all=*
          --extras-all=-{subword}

          --fields-all=*

          --if0=no

          --kinds-all=*

          --links=yes
          --recurse=yes

          --sort=yes

          --tag-relative=yes

          --totals=yes
        '';
      };
    };
  }
