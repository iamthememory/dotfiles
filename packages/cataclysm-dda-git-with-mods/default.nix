# A customized CDDA package with extra mods, patches, and tweaks.
{ applyPatches
, cataclysm-dda
, cataclysm-dda-arcana
, cataclysm-dda-cdda-arcana-technoclysm
, cataclysm-dda-cdda-extra-lives
, cataclysm-dda-dorf-life
, cataclysm-dda-e85-engines
, cataclysm-dda-elf-crops
, cataclysm-dda-git-latest
, cataclysm-dda-grow-more-drugs
, cataclysm-dda-mana-cores
, cataclysm-dda-medieval
, cataclysm-dda-minimods
, cataclysm-dda-mining-enchanced
, cataclysm-dda-mining-mod
, cataclysm-dda-mom-submods
, cataclysm-dda-mst-extra
, cataclysm-dda-no-class-limit
, cataclysm-dda-nocts
, cataclysm-dda-pm-world
, cataclysm-dda-sleepscumming
, cataclysm-dda-stats-through-kills
, cataclysm-dda-stats-through-skills
, cataclysm-dda-tankmod
, cataclysmDDA
, cdda-sounds
, cdda-tilesets
, clang
, flake-revision
, lib
, stdenv
}:
let
  # Build Cataclysm: DDA from the current source.
  cataclysm-dda-git-latest-pkg = cataclysm-dda.overrideAttrs (oldAttrs: rec {
    name = "${oldAttrs.pname}-${version}";
    version = "${cataclysm-dda-git-latest.lastModifiedDate}";
    src = cataclysm-dda-git-latest;

    patches = [
      ./patches/cataclysm-big-tiles.patch
      ./patches/cataclysm-bionics-lower-saving.patch
      ./patches/cataclysm-craft-percent-fix.patch
      ./patches/cataclysm-custom-options.patch
      ./patches/cataclysm-defense-real-world.patch
      ./patches/cataclysm-dino-egg-vitamins.patch
      ./patches/cataclysm-disable-trait-flag-cache.patch
      ./patches/cataclysm-disable-warning.patch
      ./patches/cataclysm-dream-fix.patch
      ./patches/cataclysm-exodii-bionics.patch
      ./patches/cataclysm-homullus-fix.patch
      ./patches/cataclysm-large-smokers.patch
      ./patches/cataclysm-larger-trade-range.patch
      ./patches/cataclysm-limit-refuse.patch
      ./patches/cataclysm-locale-path.patch
      ./patches/cataclysm-magiclysm-okay-potions.patch
      ./patches/cataclysm-magiclysm-renewal-height.patch
      ./patches/cataclysm-mindovermatter-contemplation.patch
      ./patches/cataclysm-mindovermatter-sidebar-fix.patch
      ./patches/cataclysm-mom-defense.patch
      ./patches/cataclysm-more-engines.patch
      ./patches/cataclysm-multiple-thresholds.patch
      ./patches/cataclysm-my-sweet-cataclysm-chance.patch
      ./patches/cataclysm-no-banned-ports.patch
      ./patches/cataclysm-no-hope-books.json
      ./patches/cataclysm-perks-fix.patch
      ./patches/cataclysm-plant-in-cold.patch
      ./patches/cataclysm-plant-only-check-now.patch
      ./patches/cataclysm-seedbearer-fix.patch
      ./patches/cataclysm-spell-ui-widen.patch
      ./patches/cataclysm-survival-forage.patch
      ./patches/cataclysm-xedra-chronomancer-heritage.patch
      ./patches/cataclysm-xedra-dream.patch
      ./patches/cataclysm-xedra-dreamdross.patch
      ./patches/cataclysm-xedra-nail.patch
      ./patches/cataclysm-xedra-wallet.patch
    ];

    # Build with clang, as upstream does.
    # Weird way to do it, but it's how CDDA's workflow specifies the compiler.
    makeFlags = oldAttrs.makeFlags ++ [
      "COMPILER=clang++"
    ];

    # Make sure to include clang in our build environment.
    nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [
      clang
    ];

    # Enable debugging info.
    dontStrip = true;
    env.NIX_CFLAGS_COMPILE = toString (oldAttrs.env.NIX_CFLAGS_COMPILE or "") + " -ggdb";

    # Enable tiles.
    tiles = true;
  });

  # CDDA mods.

  arcana = cataclysmDDA.buildMod {
    modName = "Arcana";
    version = cataclysm-dda-arcana.lastModifiedDate;
    src = applyPatches {
      name = "cataclysm-dda-arcana-patched";
      src = cataclysm-dda-arcana;
      patches = [
        ./patches/cataclysm-arcana-fix.patch
      ];
    };
    modRoot = "Arcana";
  };

  cdda-arcana-technoclysm = cataclysmDDA.buildMod {
    modName = "arcana-technoclysm";
    version = cataclysm-dda-cdda-arcana-technoclysm.lastModifiedDate;
    src = cataclysm-dda-cdda-arcana-technoclysm;
  };

  cdda-extra-lives = cataclysmDDA.buildMod {
    modName = "extra_lives_extended";
    src = cataclysm-dda-cdda-extra-lives;
    version = cataclysm-dda-cdda-extra-lives.lastModifiedDate;
  };

  cc-sounds = cataclysmDDA.buildSoundPack {
    modName = "CC-Sounds";
    version = cdda-sounds.lastModifiedDate;
    src = cdda-sounds;
    modRoot = "sound/CC-Sounds";
  };

  cdda-tilesets-built =
    let
      tileset-packages-unfiltered =
        cdda-tilesets.outputs.packages."${stdenv.hostPlatform.system}";

      # Ultica_iso fails as a flakedue to symlinks outside of its directory.
      tileset-packages =
        lib.attrsets.filterAttrs
          (n: v: n != "Ultica_iso")
          tileset-packages-unfiltered;

      makeTileset = modName: deriv: cataclysmDDA.buildTileSet {
        inherit modName;
        version = deriv.version;
        src = deriv;
      };

      tilesetSet = builtins.mapAttrs makeTileset tileset-packages;

      tilesets = builtins.attrValues tilesetSet;
    in
    tilesets;

  dorf-life = cataclysmDDA.buildMod {
    modName = "Dorf_Life";
    src = applyPatches {
      name = "cataclysm-dda-dorf-life-patched";
      src = cataclysm-dda-dorf-life;
      patches = [
        ./patches/cataclysm-dorf-life-fix.patch
      ];
    };
    version = cataclysm-dda-dorf-life.lastModifiedDate;
    modRoot = "Dorf_Life";
  };

  elfmods =
    let
      patched-src = applyPatches {
        name = "elfcrops-patched";
        src = cataclysm-dda-elf-crops;
        patches = [
          ./patches/cataclysm-elfcrops-fixdup.patch
        ];
      };

      elfmod = modRoot: modName: cataclysmDDA.buildMod {
        inherit modName modRoot;
        version = cataclysm-dda-elf-crops.lastModifiedDate;
        src = patched-src;
      };
    in
    builtins.attrValues (builtins.mapAttrs elfmod {
      "Plant Crops" = "resource_crops_plants";
      "Resource Crops" = "resource_crops";
      "Resource Crops Magiclysm addon" = "resource_cropsMagic";
    });

  e85-engines = cataclysmDDA.buildMod {
    modName = "E85_Engines";
    version = cataclysm-dda-e85-engines.lastModifiedDate;
    src = applyPatches {
      name = "cataclysm-dda-e85-engines-patched";
      src = cataclysm-dda-e85-engines;
      patches = [
        ./patches/cataclysm-e85-fix.patch
      ];
    };
  };

  grow-more-drugs = cataclysmDDA.buildMod {
    modName = "grow_more_drugs";
    version = cataclysm-dda-grow-more-drugs.lastModifiedDate;
    src = applyPatches {
      name = "grow_more_drugs-patched";
      src = cataclysm-dda-grow-more-drugs;
      patches = [
        ./patches/cataclysm-grow-more-drugs-fix.patch
      ];
    };
    modRoot = "mods/grow_more_drugs";
  };

  magiclysm-no-class-limit = cataclysmDDA.buildMod {
    modName = "Magiclysm_No_Class_Limit";
    version = cataclysm-dda-no-class-limit.lastModifiedDate;
    src = applyPatches {
      name = "cataclysm-dda-no-class-limit";
      src = cataclysm-dda-no-class-limit;
    };
  };

  mana-cores = cataclysmDDA.buildMod {
    modName = "manacores";
    version = cataclysm-dda-medieval.lastModifiedDate;
    src = applyPatches {
      name = "cataclysm-dda-mana-cores-patched";
      src = cataclysm-dda-mana-cores;
      patches = [
        ./patches/cataclysm-mana-cores.patch
      ];
    };
    modRoot = "Mana-Cores";
  };

  medieval = cataclysmDDA.buildMod {
    modName = "Medieval_Mod_Reborn";
    version = cataclysm-dda-medieval.lastModifiedDate;
    src = applyPatches {
      name = "cataclysm-dda-medieval-patched";
      src = cataclysm-dda-medieval;
      patches = [
        ./patches/cataclysm-medieval-fix.patch
      ];
    };
    modRoot = "Medieval_Mod_Reborn";
  };

  minimods =
    let
      patched-src = applyPatches {
        name = "cataclysm-dda-minimods-patched";
        src = cataclysm-dda-minimods;
        patches = [
          ./patches/cataclysm-minimods-fix.patch
        ];
      };

      mini-mod = modRoot: modName: cataclysmDDA.buildMod {
        inherit modName modRoot;
        version = cataclysm-dda-minimods.lastModifiedDate;
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

  mining-enchanced = cataclysmDDA.buildMod {
    modName = "Mining_enchanced_Mod";
    version = cataclysm-dda-mining-enchanced.lastModifiedDate;
    src = applyPatches {
      name = "cataclysm-dda-mining-enchanced-patched";
      src = cataclysm-dda-mining-enchanced;
      patches = [
        ./patches/cataclysm-mining-enchanced.patch
      ];
    };
    modRoot = "Mining_Enchanced_0.2.1";
  };

  mining-mod = cataclysmDDA.buildMod {
    modName = "Mining_Mod";
    version = cataclysm-dda-mining-mod.lastModifiedDate;
    src = applyPatches {
      name = "cataclysm-dda-mining-mod-patched";
      src = cataclysm-dda-mining-mod;
      patches = [
        ./patches/cataclysm-mining-mod-fix.patch
      ];
    };
    modRoot = "Mining_Mod";
  };

  mom-submods =
    let
      mom-src = applyPatches {
        name = "cataclysm-dda-mom-submods-patched";
        src = cataclysm-dda-mom-submods;
        patches = [
          ./patches/cataclysm-mom-submods-fix.patch
        ];
      };

      mom-mod = modRoot: modName: cataclysmDDA.buildMod {
        inherit modName modRoot;
        version = cataclysm-dda-mom-submods.lastModifiedDate;
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

  mst-extra = cataclysmDDA.buildMod {
    modName = "MST_Extra";
    version = cataclysm-dda-mst-extra.lastModifiedDate;
    src = applyPatches {
      name = "cataclysm-dda-mst-extra-patched";
      src = cataclysm-dda-mst-extra;
      patches = [
        ./patches/cataclysm-mst-fix.patch
      ];
    };
    modRoot = "MST_Extra";
  };

  nocts = cataclysmDDA.buildMod {
    modName = "Cata++";
    version = cataclysm-dda-nocts.lastModifiedDate;
    src = applyPatches {
      name = "cataclysm-dda-nocts-patched";
      src = cataclysm-dda-nocts;
      patches = [
        ./patches/cataclysm-nocts-fix.patch
      ];
    };
    modRoot = "nocts_cata_mod_DDA";
  };

  pm-world = cataclysmDDA.buildMod {
    modName = "pm_world";
    version = cataclysm-dda-pm-world.lastModifiedDate;
    src = applyPatches {
      name = "cataclysm-dda-pm-world-patched";
      src = cataclysm-dda-pm-world;
      patches = [
        ./patches/cataclysm-pm-fix.patch
      ];
    };
  };

  sleepscumming-keep = cataclysmDDA.buildMod {
    modName = "sleepscumming_keep_your_stuff";
    version = cataclysm-dda-sleepscumming.lastModifiedDate;
    src = cataclysm-dda-sleepscumming;
    modRoot = "sleepscumming_keep_stuff";
  };

  sleepscumming-lose = cataclysmDDA.buildMod {
    modName = "sleepscumming_lose_your_stuff";
    version = cataclysm-dda-sleepscumming.lastModifiedDate;
    src = cataclysm-dda-sleepscumming;
    modRoot = "sleepscuming-lose-your-stuff";
  };

  stats-through-kills = cataclysmDDA.buildMod {
    modName = "stk_eoc";
    version = cataclysm-dda-stats-through-kills.lastModifiedDate;
    src = cataclysm-dda-stats-through-kills;
  };

  stats-through-skills = cataclysmDDA.buildMod {
    modName = "StatsThroughSkills";
    version = cataclysm-dda-stats-through-skills.lastModifiedDate;
    src = cataclysm-dda-stats-through-skills;
  };

  tankmod = cataclysmDDA.buildMod {
    modName = "Tankmod_Revived";
    version = cataclysm-dda-tankmod.lastModifiedDate;
    src = applyPatches {
      name = "cataclysm-dda-tankmod-patched";
      src = cataclysm-dda-tankmod;
      patches = [
        ./patches/cataclysm-tankmod-fix.patch
      ];
    };
    modRoot = "Tankmod_Revived";
  };

  # My mods.

  backrooms-tweaks = cataclysmDDA.buildMod {
    modName = "backrooms-tweaks";
    version = flake-revision;
    src = ./backrooms-tweaks;
  };

  cdda-defense-additions = cataclysmDDA.buildMod {
    modName = "cdda-defense-additions";
    version = flake-revision;
    src = ./cdda-defense-additions;
  };

  extra-fruits = cataclysmDDA.buildMod {
    modName = "extra-fruits";
    version = flake-revision;
    src = ./extra-fruits;
  };

  fast-craft-slow-skill = cataclysmDDA.buildMod {
    modName = "fast-craft-slow-skill";
    version = flake-revision;
    src = ./fast-craft-slow-skill;
  };

  innawoods-compat = cataclysmDDA.buildMod {
    modName = "innawoods-compat";
    version = flake-revision;
    src = ./innawoods-compat;
  };

  lab-loot-extras = cataclysmDDA.buildMod {
    modName = "lab-loot-extras";
    version = flake-revision;
    src = ./lab-loot-extras;
  };

  magiclysm-linear-leveling = cataclysmDDA.buildMod {
    modName = "magiclysm-linear-leveling";
    version = flake-revision;
    src = ./magiclysm-linear-leveling;
  };

  magiclysm-non-exclusive-attunements = cataclysmDDA.buildMod {
    modName = "magiclysm-non-exclusive-attunements";
    version = flake-revision;
    src = ./magiclysm-non-exclusive-attunements;
  };

  magic-loot-perks = cataclysmDDA.buildMod {
    modName = "magic-loot-perks";
    version = flake-revision;
    src = ./magic-loot-perks;
  };

  no-overgrowth = cataclysmDDA.buildMod {
    modName = "no-overgrowth";
    version = flake-revision;
    src = ./no-overgrowth;
  };

  random-stuff = cataclysmDDA.buildMod {
    modName = "random-stuff";
    version = flake-revision;
    src = ./random-stuff;
  };

  trickle-exp = cataclysmDDA.buildMod {
    modName = "trickle-exp";
    version = flake-revision;
    src = ./trickle-exp;
  };

  xedra-both-classes = cataclysmDDA.buildMod {
    modName = "xedra-both-classes";
    version = flake-revision;
    src = ./xedra-both-classes;
  };

  xedra-disable-leveling = cataclysmDDA.buildMod {
    modName = "xedra-disable-leveling";
    version = flake-revision;
    src = ./xedra-disable-leveling;
  };

  xedra-seedbearer-always = cataclysmDDA.buildMod {
    modName = "xedra-seedbearer-always";
    version = flake-revision;
    src = ./xedra-seedbearer-always;
  };

  # CDDA with extra mods.
  cataclysm-dda-git-with-mods =
    cataclysmDDA.wrapCDDA cataclysm-dda-git-latest-pkg (mods: [
      arcana
      backrooms-tweaks
      cc-sounds
      cdda-arcana-technoclysm
      cdda-defense-additions
      cdda-extra-lives
      cdda-tilesets-built
      dorf-life
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
      mana-cores
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
in
cataclysm-dda-git-with-mods
