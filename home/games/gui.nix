# GUI-based games and their configurations.
{ config
, inputs
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
      # Build Cataclysm: DDA from the current source.
      cataclysm-dda-git-latest = pkgs.cataclysm-dda.overrideAttrs (oldAttrs: rec {
        name = "${oldAttrs.pname}-${version}";
        version = "${inputs.cataclysm-dda.lastModifiedDate}";
        src = inputs.cataclysm-dda;

        patches = [
          ./cataclysm-locale-path.patch
        ];

        # Enable tiles.
        tiles = true;
      });

      magiclysm-no-class-limit = pkgs.cataclysmDDA.buildMod {
        modName = "Magiclysm_No_Class_Limit";
        version = inputs.cataclysm-dda-no-class-limit.lastModifiedDate;
        src = inputs.cataclysm-dda-no-class-limit;
      };

      mining-mod = pkgs.cataclysmDDA.buildMod {
        modName = "Mining_Mod";
        version = inputs.cataclysm-dda-mining-mod.lastModifiedDate;
        src = inputs.cataclysm-dda-mining-mod;
        modRoot = "Mining_Mod";
      };

      cataclysm-dda-git-with-mods = pkgs.cataclysmDDA.wrapCDDA cataclysm-dda-git-latest (mods: [
        magiclysm-no-class-limit
        mining-mod
      ]);

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
      cataclysm-dda-git-with-mods

      # A mod manager for Kerbal Space Program.
      ckan

      # Dwarf Fortress with Dwarf Therapist and dfhack.
      dwarf-fortress-custom

      # Freeciv.
      freeciv_gtk

      # A game overlay.
      mangohud

      # A Minecraft launcher and manager.
      prismlauncher

      # An emulator.
      retroarchFull

      # An old-school Runescape client.
      runelite

      # A Minecraft-like survival game.
      vintagestory
    ];

  xdg.configFile."MangoHud/MangoHud.conf".text = mangoHudDefaults;

  xdg.configFile."MangoHud/wine-eldenring.conf".text = mangoHudDefaults + ''
    # Show the HUD in the top-right.
    position=top-right
  '';
}
