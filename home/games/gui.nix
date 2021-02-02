# GUI-based games and their configurations.
{ pkgs
, ...
}: {
  home.packages = with pkgs; [
    # Cataclysm: DDA, built from git and with the GUI enabled.
    cataclysmDDA.git.tiles

    # Dwarf Fortress with Dwarf Therapist and dfhack.
    (dwarf-fortress-packages.dwarf-fortress-full.override {
      # Disable the intro video.
      enableIntro = false;

      # Enable the FPS counter.
      enableFPS = true;
    })

    # Freeciv.
    freeciv_gtk
  ];
}
