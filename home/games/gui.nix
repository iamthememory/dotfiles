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

        # Upstream cataclysm-dda renamed its desktop file and icon.
        postInstall =
          let
            from = [
              "data/xdg/*cataclysm-dda.desktop"
              "data/xdg/cataclysm-dda.svg"
            ];

            to = [
              "data/xdg/org.cataclysmdda.CataclysmDDA.desktop"
              "data/xdg/org.cataclysmdda.CataclysmDDA.svg"
            ];
          in
          builtins.replaceStrings from to oldAttrs.postInstall;

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

      # A mod manager for Kerbal Space Program.
      ckan

      # A Minecraft launcher and manager.
      multimc
    ];
}
