{ config, ... }:
let
  inherit (import ../channels.nix) unstable;

  mkscript = f: import f { pkgs = unstable; inherit config; };
in
  {
    fixup-paths = mkscript ./fixup-paths.nix;
    speedswapper = mkscript ./speedswapper.nix;
    start-tmux-x = mkscript ./start-tmux-x.nix;
    take-screenshot = mkscript ./take-screenshot.nix;
    toggle-mute = mkscript ./toggle-mute.nix;
  }
