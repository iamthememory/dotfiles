# GUI-based games and their configurations.
{ inputs
, pkgs
, ...
}: {
  home.packages = with pkgs; [
    # Cataclysm: DDA.
    cataclysm-dda-git

    # A mod manager for Kerbal Space Program.
    ckan

    # Dwarf Fortress with Dwarf Therapist and dfhack.
    (dwarf-fortress-packages.dwarf-fortress-full.override {
      # Disable the intro video.
      enableIntro = false;

      # Enable the FPS counter.
      enableFPS = true;
    })

    # Freeciv.
    freeciv_gtk

    # A Minecraft launcher and manager.
    polymc
  ];
}
