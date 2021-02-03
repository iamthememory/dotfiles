# GUI-based games and their configurations.
{ inputs
, pkgs
, ...
}: {
  home.packages = with pkgs;
    let
      # Build Cataclysm: DDA from the current source.
      cataclysm-dda-git = pkgs.cataclysm-dda.overrideAttrs (oldAttrs: rec {
        name = "${oldAttrs.pname}-${version}";
        version = "${inputs.cataclysm-dda.lastModifiedDate}";
        src = inputs.cataclysm-dda;

        # Enable tiles.
        tiles = true;
      });
    in
    [
      # Cataclysm: DDA, built from git and with the GUI enabled.
      cataclysm-dda-git

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
