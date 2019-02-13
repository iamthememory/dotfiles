{ config, ... }:
let
  inherit (import ../channels.nix) unstable;

  mkscript = f: import f { pkgs = unstable; inherit config; };
in
  {
    fixup-paths = mkscript ./fixup-paths.nix;
    i3pystatus-bottom = mkscript ./i3pystatus-bottom.nix;
    i3pystatus-top = mkscript ./i3pystatus-top.nix;
    speedswapper = mkscript ./speedswapper.nix;
    start-tmux-x = mkscript ./start-tmux-x.nix;
    take-screenshot = mkscript ./take-screenshot.nix;
    toggle-mute = mkscript ./toggle-mute.nix;
  }
