# GUI-based games and their configurations.
{ config
, inputs
, lib
, pkgs
, ...
}:
let
  mangoHudDefaults = ''
    # Show the time.
    time
    time_format=%a %Y-%m-%d %H:%M:%S %z
    time_no_label

    # Show CPU info.
    cpu_stats
    core_load
    core_bars
    cpu_temp

    # Show GPU info.
    gpu_stats
    gpu_temp

    # Show memory.
    procmem
    ram
    vram
    swap

    # Show FPS info.
    fps
    frametime

    # Show IO.
    io_read
    io_write
    network=enp3s0,enp4s0,wlp5s0

    # Show wine.
    wine

    # Show battery info.
    battery

    # Show throttling.
    throttling_status

    # Show frame timing.
    frame_timing

    # Use LiterationMono.
    font_file=${config.home.profileDirectory}/share/fonts/truetype/NerdFonts/LiterationMonoNerdFontMono-Regular.ttf
    font_size=16

    # Use a more compact HUD.
    hud_compact

    # Outline text.
    text_outline

    # Increase transparency.
    background_alpha = 0.2
    alpha = 0.4

    # Reload config.
    reload_cfg=Shift_L+F4

    # Toggle HUD position.
    toggle_hud_position=Shift_R+F11

    # Toggle HUD.
    toggle_hud=Shift_R+F12
  '';
in
{
  home.packages =
    let
      # The customized dwarf fortress to use.
      dwarf-fortress-custom = (pkgs.dwarf-fortress-packages.dwarf-fortress-full.override {
        # Disable the intro video.
        enableIntro = false;

        # Enable the FPS counter.
        enableFPS = true;

        # Use the mayday theme.
        theme = pkgs.dwarf-fortress-packages.themes.mayday;
      });
    in
    with pkgs; [
      # Cataclysm: DDA.
      inputs.flake.outputs.packages."${pkgs.stdenv.hostPlatform.system}".cataclysm-dda-git-with-mods

      # A mod manager for Kerbal Space Program.
      ckan

      # Dwarf Fortress with Dwarf Therapist and dfhack.
      dwarf-fortress-custom

      # Freeciv.
      freeciv_gtk

      # A game overlay.
      mangohud

      # A GBA emulator.
      mgba

      # A Minecraft launcher and manager.
      prismlauncher

      # An emulator.
      retroarch-full

      # An old-school Runescape client.
      runelite

      # The launcher for SS14.
      space-station-14-launcher

      # A Minecraft-like survival game.
      vintagestory
    ];

  xdg.configFile."MangoHud/MangoHud.conf".text = mangoHudDefaults;

  xdg.configFile."MangoHud/wine-eldenring.conf".text = mangoHudDefaults + ''
    # Show the HUD in the top-right.
    position=top-right
  '';
}
