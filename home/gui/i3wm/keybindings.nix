{ config, lib, options, ... }:
let
  inherit (import ../../channels.nix) unstable;

  scripts = import ../../scripts { inherit config; };

  modifier = config.xsession.windowManager.i3.config.modifier;

  pkgs = unstable;
in
  {
    xsession.windowManager.i3.config.modifier = "Mod1";

    xsession.windowManager.i3.config.keybindings = {
      "XF86AudioLowerVolume" = "exec \"${pkgs.pamixer}/bin/pamixer --decrease 5";
      "XF86AudioMute" = "exec ${scripts.toggle-mute}";
      "XF86AudioNext" = "exec ${pkgs.playerctl}/bin/playerctl --player=spotify next";
      "XF86AudioPause" = "exec ${pkgs.playerctl}/bin/playerctl --player=spotify play-pause";
      "XF86AudioPlay" = "exec ${pkgs.playerctl}/bin/playerctl --player=spotify play-pause";
      "XF86AudioPrev" = "exec ${pkgs.playerctl}/bin/playerctl --player=spotify previous";
      "XF86AudioRaiseVolume" = "exec \"${pkgs.pamixer}/bin/pamixer --increase 5";

      "${modifier}+Return" = "exec ${pkgs.kitty}/bin/kitty --single-instance";
      "${modifier}+Control+Shift+Return" = "exec ${pkgs.st}/bin/st";

      "${modifier}+space" = "focus mode_toggle";
      "${modifier}+Shift+space" = "floating toggle";

      "${modifier}+minus" = "scratchpad show";
      "${modifier}+Shift+minus" = "move scratchpad";

      "${modifier}+equal" = "[class=\"^Spotify$\"] scratchpad show";

      "${modifier}+1" = "workspace number 1:disc";
      "${modifier}+Shift+1" = "move container to workspace number 1:disc";

      "${modifier}+2" = "workspace number 2:sys";
      "${modifier}+Shift+2" = "move container to workspace number 2:sys";

      "${modifier}+3" = "workspace number 3:mail";
      "${modifier}+Shift+3" = "move container to workspace number 3:mail";

      "${modifier}+4" = "workspace number 4:ffdoc";
      "${modifier}+Shift+4" = "move container to workspace number 4:ffdoc";

      "${modifier}+5" = "workspace number 5:ffxiv";
      "${modifier}+Shift+5" = "move container to workspace number 5:ffxiv";

      "${modifier}+6" = "workspace number 6";
      "${modifier}+Shift+6" = "move container to workspace number 6";

      "${modifier}+7" = "workspace number 7";
      "${modifier}+Shift+7" = "move container to workspace number 7";

      "${modifier}+8" = "workspace number 8:slack";
      "${modifier}+Shift+8" = "move container to workspace number 8:slack";

      "${modifier}+9" = "workspace number 9:misc";
      "${modifier}+Shift+9" = "move container to workspace number 9:misc";

      "${modifier}+0" = "workspace number 10:steam";
      "${modifier}+Shift+0" = "move container to workspace number 10:steam";

      "${modifier}+a" = "focus parent";
      "${modifier}+Shift+a" = "exec ${pkgs.pass}/bin/passmenu --type";
      "${modifier}+Control+a" = "exec ${pkgs.pass}/bin/passmenu";
      "${modifier}+Control+Shift+a" = "exec ${pkgs.autorandr}/bin/autorandr -c";

      "${modifier}+Shift+b" = "exec ${pkgs.pulseaudio}/bin/pactl suspend-sink 1 && ${pkgs.pulseaudio}/bin/pactl suspend-sink 0";

      "${modifier}+c" = "focus child";
      "${modifier}+Control+c" = "exec ${config.programs.chromium.package}/bin/chromium-browser";
      "${modifier}+Control+Shift+c" = "exec ${config.programs.chromium.package}/bin/chromium-browser --incognito";

      "${modifier}+d" = "exec ${pkgs.dmenu}/bin/dmenu_run";
      "${modifier}+Shift+d" = "exec ${pkgs.i3}/bin/i3-dmenu-desktop";

      "${modifier}+e" = "layout toggle split";
      "${modifier}+Shift+e" = "exec \"${pkgs.i3}/bin/i3-nagbar -t warning -m 'You pressed the exit shortcut. Do you really want to exit i3? This will end your X session.' -b 'Yes, exit i3' '${pkgs.i3}/bin/i3-msg exit & ${pkgs.coreutils}/bin/sleep 10 && ${pkgs.systemd}/bin/loginctl terminate-session \$XDG_SESSION_ID'\"";

      "${modifier}+f" = "fullscreen toggle";
      "${modifier}+Control+Shift+f" = "exec ${pkgs.playonlinux}/bin/playonlinux --run 'FINAL FANTASY XIV - A Realm Reborn'";

      "${modifier}+Control+Shift+g" = "exec ${pkgs.xorg.xmodmap}/bin/xmodmap ${scripts.speedswapper}";

      "${modifier}+h" = "focus left";
      "${modifier}+Shift+h" = "move left";
      "${modifier}+Control+Shift+h" = "exec ${pkgs.st}/bin/st -e ${pkgs.htop}/bin/htop";

      "${modifier}+i" = "exec ${pkgs.i3}/bin/i3-input";

      "${modifier}+j" = "focus down";
      "${modifier}+Shift+j" = "move down";

      "${modifier}+k" = "focus up";
      "${modifier}+Shift+k" = "move up";

      "${modifier}+l" = "focus right";
      "${modifier}+Shift+l" = "move right";
      "${modifier}+Control+Shift+l" = "exec ${pkgs.xorg.xset}/bin/xset s activate";

      "${modifier}+Control+Shift+m" = "exec ${pkgs.ftb}/bin/ftb-launch.sh";

      "${modifier}+n" = "workspace next";
      "${modifier}+Shift+n" = "move container to workspace next";
      "${modifier}+Control+n" = "exec ${pkgs.playerctl}/bin/playerctl --player=spotify next";
      "${modifier}+Control+Shift+n" = "exec ${pkgs.gnome3.nautilus}/bin/nautilus";

      "${modifier}+o" = "split h";

      "${modifier}+p" = "workspace prev";
      "${modifier}+Shift+p" = "move container to workspace prev";
      "${modifier}+Control+p" = "exec ${pkgs.playerctl}/bin/playerctl --player=spotify previous";
      "${modifier}+Control+Shift+p" = "exec ${pkgs.pavucontrol}/bin/pavucontrol";

      "${modifier}+Shift+q" = "kill";

      "${modifier}+r" = "mode \"resize\"";
      "${modifier}+Shift+r" = "exec ${pkgs.i3}/bin/i3-input -F 'rename workspace to \"%s\"' -P 'New name: '";
      "${modifier}+Control+r" = "reload";
      "${modifier}+Control+Shift+r" = "restart";

      "${modifier}+Control+Shift+s" = "exec ${scripts.take-screenshot}";

      "${modifier}+t" = "mode \"passthrough\"";
      "${modifier}+Shift+t" = "exec ${pkgs.xorg.xinput}/bin/xinput disable 'pointer:SynPS/2 Synaptics TouchPad'";
      "${modifier}+Control+Shift+t" = "exec ${pkgs.xorg.xinput}/bin/xinput enable 'pointer:SynPS/2 Synaptics TouchPad'";

      "${modifier}+Control+Shift+u" = "exec ${pkgs.systemd}/bin/systemctl suspend";

      "${modifier}+v" = "split v";

      "${modifier}+w" = "layout tabbed";

      "${modifier}+Control+Shift+x" = "exec ${pkgs.xorg.xkill}/bin/xkill";

      "${modifier}+Shift+y" = "exec ${pkgs.xorg.xinput}/bin/xinput disable 'Yubico Yubikey 4 OTP+U2F+CCID'";
      "${modifier}+Control+Shift+y" = "exec ${pkgs.xorg.xinput}/bin/xinput enable 'Yubico Yubikey 4 OTP+U2F+CCID'";
    };

    xsession.windowManager.i3.config.modes = {
      "resize" = {
        "Return" = "mode \"default\"";
        "Escape" = "mode \"default\"";

        "h" = "resize shrink width 10 px or 5 ppt";
        "${modifier}+h" = "resize shrink width 1 px or 1 ppt";

        "j" = "resize grow height 10 px or 5 ppt";
        "${modifier}+j" = "resize grow height 1 px or 1 ppt";

        "k" = "resize shrink height 10 px or 5 ppt";
        "${modifier}+k" = "resize shrink height 1 px or 1 ppt";

        "l" = "resize grow width 10 px or 5 ppt";
        "${modifier}+l" = "resize grow width 1 px or 1 ppt";
      };

      "passthrough" = {
        "${modifier}+t" = "mode \"default\"";
      };
    };
  }
