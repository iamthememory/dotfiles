let
  inherit (import ../channels.nix) unstable;

  mkscript = f: import f { pkgs = unstable; };
in
  {
    fixup-paths = mkscript ./fixup-paths.nix;
    speedswapper = mkscript ./speedswapper.nix;
    start-tmux-x = mkscript ./start-tmux-x.nix;
    toggle-mute = mkscript ./toggle-mute.nix;
  }
