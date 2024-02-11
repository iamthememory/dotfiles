# GUI-based games and their configurations.
{ inputs
, pkgs
, ...
}: {
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
      # FIXME: Use stable until this compiles with GCC 13.
      inputs.stable.cataclysm-dda

      # A mod manager for Kerbal Space Program.
      ckan

      # Dwarf Fortress with Dwarf Therapist and dfhack.
      dwarf-fortress-custom

      # Freeciv.
      freeciv_gtk

      # A Minecraft launcher and manager.
      prismlauncher

      # A Minecraft-like survival game.
      vintagestory
    ];
}
