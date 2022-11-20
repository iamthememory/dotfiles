# GUI-based games and their configurations.
{ inputs
, pkgs
, ...
}: {
  home.packages =
    let
      # Pull in a patched nixpkgs with an update to dfhack.
      # This should be dropped once NixOS/nixpkgs#201568 or an equivalent is
      # merged.
      df-pkgs =
        let
          patched-pkgs = pkgs.applyPatches {
            name = "nixos-unstable-201568";
            src = inputs.flake.inputs.nixos-unstable;
            patches = [ ./nixpkgs-dwarf-fortress-201568.patch ];
          };
        in
        import patched-pkgs { inherit (pkgs) config overlays system; };

      # The customized dwarf fortress to use.
      dwarf-fortress-custom = (df-pkgs.dwarf-fortress-packages.dwarf-fortress-full.override {
        # Disable the intro video.
        enableIntro = false;

        # Enable the FPS counter.
        enableFPS = true;

        # Use the mayday theme.
        theme = df-pkgs.dwarf-fortress-packages.themes.mayday;
      });
    in
    with pkgs; [
      # Cataclysm: DDA.
      cataclysm-dda-git

      # A mod manager for Kerbal Space Program.
      ckan

      # Dwarf Fortress with Dwarf Therapist and dfhack.
      dwarf-fortress-custom

      # Freeciv.
      freeciv_gtk

      # A Minecraft launcher and manager.
      prismlauncher
    ];
}
