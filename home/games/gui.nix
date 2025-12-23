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
      # Build Cataclysm: DDA from the current source.
      cataclysm-dda-git-latest = pkgs.cataclysm-dda.overrideAttrs (oldAttrs: rec {
        name = "${oldAttrs.pname}-${version}";
        version = "${inputs.cataclysm-dda.lastModifiedDate}";
        src = inputs.cataclysm-dda;

        patches = [
          ./cataclysm-84297.patch
          ./cataclysm-bionics-lower-saving.patch
          ./cataclysm-craft-percent-fix.patch
          ./cataclysm-custom-options.patch
          ./cataclysm-defense-real-world.patch
          ./cataclysm-dino-egg-vitamins.patch
          ./cataclysm-disable-trait-flag-cache.patch
          ./cataclysm-disable-warning.patch
          ./cataclysm-dream-fix.patch
          ./cataclysm-exodii-bionics.patch
          ./cataclysm-homullus-fix.patch
          ./cataclysm-larger-trade-range.patch
          ./cataclysm-locale-path.patch
          ./cataclysm-magiclysm-artificer.patch
          ./cataclysm-magiclysm-okay-potions.patch
          ./cataclysm-magiclysm-renewal-height.patch
          ./cataclysm-mindovermatter-contemplation.patch
          ./cataclysm-mindovermatter-sidebar-fix.patch
          ./cataclysm-mom-defense.patch
          ./cataclysm-more-engines.patch
          ./cataclysm-multiple-thresholds.patch
          ./cataclysm-no-moving-sand-grains-with-tweezers.patch
          ./cataclysm-perks-fix.patch
          ./cataclysm-plant-in-cold.patch
          ./cataclysm-plant-only-check-now.patch
          ./cataclysm-seedbearer-fix.patch
          ./cataclysm-sky-island-craft-fix.patch
          ./cataclysm-sky-island-range.patch
          ./cataclysm-spell-ui-widen.patch
          ./cataclysm-survival-forage.patch
          ./cataclysm-xedra-chronomancer-heritage.patch
          ./cataclysm-xedra-dream.patch
          ./cataclysm-xedra-dreamdross.patch
          ./cataclysm-xedra-nail.patch
          ./cataclysm-xedra-wallet.patch
        ];

        # Enable debugging info.
        dontStrip = true;
        env.NIX_CFLAGS_COMPILE = toString (oldAttrs.env.NIX_CFLAGS_COMPILE or "") + " -ggdb";

        # Enable tiles.
        tiles = true;
      });

      # CDDA mods.

      arcana = pkgs.cataclysmDDA.buildMod {
        modName = "Arcana";
        version = inputs.cataclysm-dda-arcana.lastModifiedDate;
        src = pkgs.applyPatches {
          name = "cataclysm-dda-arcana-patched";
          src = inputs.cataclysm-dda-arcana;
          patches = [
            ./cataclysm-arcana-fix.patch
          ];
        };
        modRoot = "Arcana";
      };

      cc-sounds = pkgs.cataclysmDDA.buildSoundPack {
        modName = "CC-Sounds";
        version = inputs.cdda-sounds.lastModifiedDate;
        src = inputs.cdda-sounds;
        modRoot = "sound/CC-Sounds";
      };

      cdda-tilesets =
        let
          tileset-packages-unfiltered =
            inputs.cdda-tilesets.outputs.packages."${pkgs.stdenv.hostPlatform.system}";

          # Ultica_iso fails as a flakedue to symlinks outside of its directory.
          tileset-packages =
            lib.attrsets.filterAttrs
              (n: v: n != "Ultica_iso")
              tileset-packages-unfiltered;

          makeTileset = modName: deriv: pkgs.cataclysmDDA.buildTileSet {
            inherit modName;
            version = deriv.version;
            src = deriv;
          };

          tilesetSet = builtins.mapAttrs makeTileset tileset-packages;

          tilesets = builtins.attrValues tilesetSet;
        in
        tilesets;


      elfmods =
        let
          patched-src = pkgs.applyPatches {
            name = "elfcrops-patched";
            src = inputs.cataclysm-dda-elf-crops;
            patches = [
              ./cataclysm-elfcrops-fixdup.patch
            ];
          };

          elfmod = modRoot: modName: pkgs.cataclysmDDA.buildMod {
            inherit modName modRoot;
            version = inputs.cataclysm-dda-elf-crops.lastModifiedDate;
            src = patched-src;
          };
        in
        builtins.attrValues (builtins.mapAttrs elfmod {
          "Plant Crops" = "resource_crops_plants";
          "Resource Crops" = "resource_crops";
          "Resource Crops Magiclysm addon" = "resource_cropsMagic";
        });

      e85-engines = pkgs.cataclysmDDA.buildMod {
        modName = "E85_Engines";
        version = inputs.cataclysm-dda-e85-engines.lastModifiedDate;
        src = pkgs.applyPatches {
          name = "cataclysm-dda-e85-engines-patched";
          src = inputs.cataclysm-dda-e85-engines;
          patches = [
            ./cataclysm-e85-fix.patch
          ];
        };
      };

      grow-more-drugs = pkgs.cataclysmDDA.buildMod {
        modName = "grow_more_drugs";
        version = inputs.cataclysm-dda-grow-more-drugs.lastModifiedDate;
        src = pkgs.applyPatches {
          name = "grow_more_drugs-patched";
          src = inputs.cataclysm-dda-grow-more-drugs;
          patches = [
            ./cataclysm-grow-more-drugs-fix.patch
          ];
        };
        modRoot = "mods/grow_more_drugs";
      };

      magiclysm-no-class-limit = pkgs.cataclysmDDA.buildMod {
        modName = "Magiclysm_No_Class_Limit";
        version = inputs.cataclysm-dda-no-class-limit.lastModifiedDate;
        src = pkgs.applyPatches {
          name = "cataclysm-dda-no-class-limit";
          src = inputs.cataclysm-dda-no-class-limit;
          patches = [
            ./cataclysm-magiclysm-no-class-limit.patch
          ];
        };
      };

      medieval = pkgs.cataclysmDDA.buildMod {
        modName = "Medieval_Mod_Reborn";
        version = inputs.cataclysm-dda-medieval.lastModifiedDate;
        src = pkgs.applyPatches {
          name = "cataclysm-dda-medieval-patched";
          src = inputs.cataclysm-dda-medieval;
          patches = [
            ./cataclysm-medieval-fix.patch
          ];
        };
        modRoot = "Medieval_Mod_Reborn";
      };

      minimods =
        let
          patched-src = pkgs.applyPatches {
            name = "cataclysm-dda-minimods-patched";
            src = inputs.cataclysm-dda-minimods;
            patches = [
              ./cataclysm-minimods-fix.patch
            ];
          };

          mini-mod = modRoot: modName: pkgs.cataclysmDDA.buildMod {
            inherit modName modRoot;
            version = inputs.cataclysm-dda-minimods.lastModifiedDate;
            src = patched-src;
          };
        in
        builtins.attrValues (builtins.mapAttrs mini-mod {
          "Augmented_survivor" = "minimod_augmented_survivor";
          "Elemental_bionic_weapons" = "minimod_elemental_bionic_weapons";
          "No_rust" = "minimod_no_rust";
          "No_zombie_revival" = "minimod_no_zombie_revival";
          "Unpersoned" = "minimod_unpersoned";
          "Wandering_castle" = "minimod_wandering_castle";
          "War-Grappling_hook" = "war-grappling_hook";
        });

      mining-enchanced = pkgs.cataclysmDDA.buildMod {
        modName = "Mining_enchanced_Mod";
        version = inputs.cataclysm-dda-mining-enchanced.lastModifiedDate;
        src = pkgs.applyPatches {
          name = "cataclysm-dda-mining-enchanced-patched";
          src = inputs.cataclysm-dda-mining-enchanced;
          patches = [
            ./cataclysm-mining-enchanced.patch
          ];
        };
        modRoot = "Mining_Enchanced_0.2.1";
      };

      mining-mod = pkgs.cataclysmDDA.buildMod {
        modName = "Mining_Mod";
        version = inputs.cataclysm-dda-mining-mod.lastModifiedDate;
        src = pkgs.applyPatches {
          name = "cataclysm-dda-mining-mod-patched";
          src = inputs.cataclysm-dda-mining-mod;
          patches = [
            ./cataclysm-mining-mod-fix.patch
          ];
        };
        modRoot = "Mining_Mod";
      };

      mom-submods =
        let
          mom-src = pkgs.applyPatches {
            name = "cataclysm-dda-mom-submods-patched";
            src = inputs.cataclysm-dda-mom-submods;
            patches = [
              ./cataclysm-mom-submods-fix.patch
            ];
          };

          mom-mod = modRoot: modName: pkgs.cataclysmDDA.buildMod {
            inherit modName modRoot;
            version = inputs.cataclysm-dda-mom-submods.lastModifiedDate;
            src = mom-src;
          };
        in
        builtins.attrValues (builtins.mapAttrs mom-mod {
          "MoM_Always_Awaken" = "mom_always_awaken";
          "MoM_Awakening_Is_Rarer" = "mom_awakening_is_rarer";
          "MoM_Calorie_Cost_Does_Not_Cause_Weariness" =
            "mom_calorie_cost_does_not_cause_weariness";
          "MoM_Experience_Edits/Double_Experience" =
            "mom_channeling_double_experience";
          "MoM_Experience_Edits/Quadruple_Experience" =
            "mom_channeling_quadruple_experience";
          "MoM_Experience_Edits/Ten_Times_Experience" =
            "mom_channeling_ten_times_experience";
          "MoM_Feral_Psions_Always_Drop_Crystals" =
            "mom_feral_psions_always_crystals";
          "MoM_Harsher_Nether_Attunement_Scaling" =
            "mom_harsher_nether_attunement_scaling";
          "MoM_Harsher_Nether_Attunement_Scaling_No_Negative" =
            "mom_harsher_nether_attunement_scaling_no_negative";
          "MoM_Head_Explode" = "mom_head_explode";
          "MoM_Increase_Random_Power_Delay" = "mom_increase_power_learn_delay";
          "MoM_Infinite_Concentration" = "mom_infinite_concentration";
          "MoM_No_Calorie_Cost" = "mom_no_calorie_cost";
          "MoM_No_Negative_Nether_Attunement" =
            "mom_no_negative_nether_attunement";
          "MoM_No_Nether_Attunement" = "mom_no_nether_attunement";
          "MoM_No_Overload" = "mom_no_overload";
          "MoM_Power_Learning_Is_Automatic" = "mom_power_learning_is_automatic";
          "MoM_Power_Learning_Is_Harder" = "mom_power_learning_is_harder";
          "MoM_Power_Learning_Is_Instant" = "mom_power_learning_is_instant";
          "MoM_Raise_Pain_Disabling_Psi_Limit" =
            "mom_raise_pain_disables_psi_limit";
          "MoM_Remove_Learn_Path_Power_Checks_Delay" =
            "mom_no_power_path_check_learn_delay";
          "MoM_Remove_Learn_Power_Delay" = "mom_no_power_learn_delay";
          "MoM_Remove_Observed_Nether_Effects" =
            "mom_remove_observed_nether_effects";
          "MoM_Remove_Pain_Disabling_Psi_Limit" =
            "mom_remove_pain_disables_psi_limit";
          "MoM_Remove_Teleport_Volume_Limit" =
            "mom_remove_teleporter_volume_limits";
        });

      mst-extra = pkgs.cataclysmDDA.buildMod {
        modName = "MST_Extra";
        version = inputs.cataclysm-dda-mst-extra.lastModifiedDate;
        src = pkgs.applyPatches {
          name = "cataclysm-dda-mst-extra-patched";
          src = inputs.cataclysm-dda-mst-extra;
          patches = [
            ./cataclysm-mst-fix.patch
          ];
        };
        modRoot = "MST_Extra";
      };

      nocts = pkgs.cataclysmDDA.buildMod {
        modName = "Cata++";
        version = inputs.cataclysm-dda-nocts.lastModifiedDate;
        src = pkgs.applyPatches {
          name = "cataclysm-dda-nocts-patched";
          src = inputs.cataclysm-dda-nocts;
          patches = [
            ./cataclysm-nocts-fix.patch
          ];
        };
        modRoot = "nocts_cata_mod_DDA";
      };

      pm-world = pkgs.cataclysmDDA.buildMod {
        modName = "pm_world";
        version = inputs.cataclysm-dda-pm-world.lastModifiedDate;
        src = pkgs.applyPatches {
          name = "cataclysm-dda-pm-world-patched";
          src = inputs.cataclysm-dda-pm-world;
          patches = [
            ./cataclysm-pm-fix.patch
          ];
        };
      };

      sleepscumming-keep = pkgs.cataclysmDDA.buildMod {
        modName = "sleepscumming_keep_your_stuff";
        version = inputs.cataclysm-dda-sleepscumming.lastModifiedDate;
        src = inputs.cataclysm-dda-sleepscumming;
        modRoot = "sleepscumming_keep_stuff";
      };

      sleepscumming-lose = pkgs.cataclysmDDA.buildMod {
        modName = "sleepscumming_lose_your_stuff";
        version = inputs.cataclysm-dda-sleepscumming.lastModifiedDate;
        src = inputs.cataclysm-dda-sleepscumming;
        modRoot = "sleepscuming-lose-your-stuff";
      };

      stats-through-kills = pkgs.cataclysmDDA.buildMod {
        modName = "stk_eoc";
        version = inputs.cataclysm-dda-stats-through-kills.lastModifiedDate;
        src = inputs.cataclysm-dda-stats-through-kills;
      };

      stats-through-skills = pkgs.cataclysmDDA.buildMod {
        modName = "StatsThroughSkills";
        version = inputs.cataclysm-dda-stats-through-skills.lastModifiedDate;
        src = inputs.cataclysm-dda-stats-through-skills;
      };

      tankmod = pkgs.cataclysmDDA.buildMod {
        modName = "Tankmod_Revived";
        version = inputs.cataclysm-dda-tankmod.lastModifiedDate;
        src = inputs.cataclysm-dda-tankmod;
        modRoot = "Tankmod_Revived";
      };

      # My mods.

      backrooms-tweaks = pkgs.cataclysmDDA.buildMod {
        modName = "backrooms-tweaks";
        version = config.home.file."generation.rev".text;
        src = ./backrooms-tweaks;
      };

      cdda-defense-additions = pkgs.cataclysmDDA.buildMod {
        modName = "cdda-defense-additions";
        version = config.home.file."generation.rev".text;
        src = ./cdda-defense-additions;
      };

      extra-fruits = pkgs.cataclysmDDA.buildMod {
        modName = "extra-fruits";
        version = config.home.file."generation.rev".text;
        src = ./extra-fruits;
      };

      fast-craft-slow-skill = pkgs.cataclysmDDA.buildMod {
        modName = "fast-craft-slow-skill";
        version = config.home.file."generation.rev".text;
        src = ./fast-craft-slow-skill;
      };

      innawoods-compat = pkgs.cataclysmDDA.buildMod {
        modName = "innawoods-compat";
        version = config.home.file."generation.rev".text;
        src = ./innawoods-compat;
      };

      lab-loot-extras = pkgs.cataclysmDDA.buildMod {
        modName = "lab-loot-extras";
        version = config.home.file."generation.rev".text;
        src = ./lab-loot-extras;
      };

      magiclysm-linear-leveling = pkgs.cataclysmDDA.buildMod {
        modName = "magiclysm-linear-leveling";
        version = config.home.file."generation.rev".text;
        src = ./magiclysm-linear-leveling;
      };

      magiclysm-non-exclusive-attunements = pkgs.cataclysmDDA.buildMod {
        modName = "magiclysm-non-exclusive-attunements";
        version = config.home.file."generation.rev".text;
        src = ./magiclysm-non-exclusive-attunements;
      };

      magic-loot-perks = pkgs.cataclysmDDA.buildMod {
        modName = "magic-loot-perks";
        version = config.home.file."generation.rev".text;
        src = ./magic-loot-perks;
      };

      no-overgrowth = pkgs.cataclysmDDA.buildMod {
        modName = "no-overgrowth";
        version = config.home.file."generation.rev".text;
        src = ./no-overgrowth;
      };

      random-stuff = pkgs.cataclysmDDA.buildMod {
        modName = "random-stuff";
        version = config.home.file."generation.rev".text;
        src = ./random-stuff;
      };

      trickle-exp = pkgs.cataclysmDDA.buildMod {
        modName = "trickle-exp";
        version = config.home.file."generation.rev".text;
        src = ./trickle-exp;
      };

      xedra-both-classes = pkgs.cataclysmDDA.buildMod {
        modName = "xedra-both-classes";
        version = config.home.file."generation.rev".text;
        src = ./xedra-both-classes;
      };

      xedra-disable-leveling = pkgs.cataclysmDDA.buildMod {
        modName = "xedra-disable-leveling";
        version = config.home.file."generation.rev".text;
        src = ./xedra-disable-leveling;
      };

      xedra-seedbearer-always = pkgs.cataclysmDDA.buildMod {
        modName = "xedra-seedbearer-always";
        version = config.home.file."generation.rev".text;
        src = ./xedra-seedbearer-always;
      };

      # CDDA with extra mods.
      cataclysm-dda-git-with-mods = pkgs.cataclysmDDA.wrapCDDA cataclysm-dda-git-latest (mods: [
        arcana
        backrooms-tweaks
        cc-sounds
        cdda-defense-additions
        cdda-tilesets
        e85-engines
        extra-fruits
        fast-craft-slow-skill
        #grow-more-drugs
        innawoods-compat
        lab-loot-extras
        magic-loot-perks
        magiclysm-linear-leveling
        magiclysm-no-class-limit
        magiclysm-non-exclusive-attunements
        medieval
        mining-enchanced
        mining-mod
        mom-submods
        mst-extra
        no-overgrowth
        nocts
        pm-world
        random-stuff
        sleepscumming-keep
        sleepscumming-lose
        stats-through-kills
        stats-through-skills
        tankmod
        trickle-exp
        xedra-both-classes
        xedra-disable-leveling
        xedra-seedbearer-always
      ]
      ++ minimods
      ++ mom-submods
      ++ elfmods
      );

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

      # A mod manager.
      nexusmods-app-unfree

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
