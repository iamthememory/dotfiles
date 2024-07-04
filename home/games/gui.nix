# GUI-based games and their configurations.
{ inputs
, pkgs
, ...
}: {
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

      # A Minecraft launcher and manager.
      prismlauncher

      # An emulator.
      retroarchFull

      # An old-school Runescape client.
      runelite

      # A Minecraft-like survival game.
      vintagestory
    ];
}
