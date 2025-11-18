{
  description = "iamthememory's dotfiles and setup";

  inputs = {
    # Nix packages.
    nixos-stable.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixos-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";

    # The Nix user repository overlay.
    nur.url = "github:nix-community/NUR";

    # Home-manager.
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixos-unstable";
    };

    # Various flake utilities.
    flake-utils.url = "github:numtide/flake-utils";

    # A tool for running unpatched binaries.
    nix-alien.url = "github:thiagokokada/nix-alien";

    # Solarized LS_COLORS.
    dircolors-solarized = {
      url = "github:seebi/dircolors-solarized";
      flake = false;
    };

    # Solarized mutt colorschemes.
    mutt-colors-solarized = {
      url = "github:altercation/mutt-colors-solarized";
      flake = false;
    };

    # Solarized Xresources colors.
    xresources-solarized = {
      url = "github:solarized/xresources";
      flake = false;
    };

    # GDB-related things not in nixpkgs.

    # A set of additions to GDB for reverse engineering and exploiting.
    gef = {
      url = "github:hugsy/gef";
      flake = false;
    };

    # Extra scripts and structures for GEF.
    gef-extras = {
      url = "github:hugsy/gef-extras";
      flake = false;
    };

    # ZSH plugins not in nixpkgs.

    zsh-async = {
      url = "github:mafredri/zsh-async";
      flake = false;
    };

    zsh-auto-notify = {
      url = "github:MichaelAquilina/zsh-auto-notify";
      flake = false;
    };

    # A patched, more up-to-date tinyfugue.
    tinyfugue-patched = {
      url = "github:ingwarsw/tinyfugue";
      flake = false;
    };

    cataclysm-dda = {
      url = "github:CleverRaven/Cataclysm-DDA";
      flake = false;
    };

    cataclysm-dda-arcana = {
      url = "github:Standing-Storm/cdda-arcana-mod";
      flake = false;
    };

    cataclysm-dda-e85-engines = {
      url = "github:Tvoqalega/E85-Engines";
      flake = false;
    };

    cataclysm-dda-elf-crops = {
      url = "github:OromisElf/ElfCrops";
      flake = false;
    };

    cataclysm-dda-grow-more-drugs = {
      url = "github:jackledead/grow_more_drugs";
      flake = false;
    };

    cataclysm-dda-medieval = {
      url = "github:chaosvolt/cdda_medieval_mod_reborn";
      flake = false;
    };

    cataclysm-dda-mining-enchanced = {
      url = "github:xGorax/CDDA-Mining-enchanced-Mod";
      flake = false;
    };

    cataclysm-dda-minimods = {
      url = "github:John-Candlebury/CDDA-Minimods";
      flake = false;
    };

    cataclysm-dda-mining-mod = {
      url = "github:chaosvolt/mining-mod";
      flake = false;
    };

    cataclysm-dda-mom-submods = {
      url = "github:Standing-Storm/mind-over-matter-submods";
      flake = false;
    };

    cataclysm-dda-mst-extra = {
      url = "github:chaosvolt/MST_Extra_Mod";
      flake = false;
    };

    cataclysm-dda-no-class-limit = {
      url = "github:martinrhan/Magiclysm_No_Class_Limit";
      flake = false;
    };

    cataclysm-dda-nocts = {
      url = "github:Noctifer-de-Mortem/nocts_cata_mod";
      flake = false;
    };

    cataclysm-dda-pm-world = {
      url = "github:Sliperr34/PM_World";
      flake = false;
    };

    cataclysm-dda-sleepscumming = {
      url = "github:Standing-Storm/sleepscumming";
      flake = false;
    };
    cataclysm-dda-stats-through-kills = {
      url = "github:KamikazieBoater/StatsThroughKills-EOC";
      flake = false;
    };

    cataclysm-dda-stats-through-skills = {
      url = "github:Erin105/StatsThroughSkills";
      flake = false;
    };

    cataclysm-dda-tankmod = {
      url = "github:chaosvolt/cdda-tankmod-revived-mod";
      flake = false;
    };

    cdda-sounds = {
      url = "git+https://github.com/Fris0uman/CDDA-Soundpacks?submodules=1";
      flake = false;
    };

    cdda-tilesets = {
      url = "github:I-am-Erk/CDDA-Tilesets";
    };

    # Nightly Rust builds.
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
    };
  };

  outputs =
    { self
    , nixos-stable
    , nixos-unstable
    , nixpkgs-master
    , home-manager
    , flake-utils
    , ...
    }@inputs:
    let
      defaultInputs =
        let
          # Exclude self and the un-initialized nixpkgs when passing inputs to
          # home-manager.
          blacklist = [
            "self"
            "nur"
          ];

          notBlacklisted = n: v: !(builtins.elem n blacklist);
        in
        nixos-stable.lib.filterAttrs notBlacklisted inputs;

      hosts = [
        "nightmare"
      ];

      lib = ./lib;

      overlay = ./overlay;

      scripts = ./scripts;

      nixpkgs-config = ./config.nix;

      mkHost =
        { host
        , username ? "iamthememory"
        , homeDirectory ? "/home/${username}"
        , system ? "x86_64-linux"
        , unimportedInputs ? defaultInputs
        , nixpkgs ? nixos-unstable
        ,
        }:
        let
          hostfile = ./home/hosts + "/${host}";

          importPkgs = p: import p {
            inherit system;

            config = import nixpkgs-config;

            overlays = [
              (import overlay)
            ];
          };

          pkgs = importPkgs nixpkgs;
          unstable = importPkgs nixos-unstable;
          stable = importPkgs nixos-stable;
          master = importPkgs nixpkgs-master;

          nur = (import nixpkgs {
            inherit system;

            config = import nixpkgs-config;

            overlays = [
              inputs.nur.overlays.default
              (import overlay)
            ];
          }).nur;

          rust-bin = (import nixpkgs {
            inherit system;

            config = import nixpkgs-config;

            overlays = [
              (import overlay)
              inputs.rust-overlay.overlays.default
            ];
          }).rust-bin;

          importedInputs = unimportedInputs // {
            inherit unstable stable master nur nixpkgs-config overlay rust-bin;

            hostname = host;

            flake = self;
            lib = import lib { inherit pkgs; };
            scripts = import scripts { inherit pkgs; };
          };
        in
        home-manager.lib.homeManagerConfiguration {
          modules = [
            hostfile

            {
              home = {
                inherit username homeDirectory;
              };

              _module.args.inputs = importedInputs;
            }
          ];

          inherit pkgs;
        };

      mkOSHost =
        { host
        , system ? "x86_64-linux"
        , nixpkgs ? nixos-unstable
        }:
        let
          hostfile = ./nixos/hosts + "/${host}";
        in
        nixpkgs.lib.nixosSystem {
          inherit system;

          modules = [
            ({
              _module.args.inputs = defaultInputs // {
                inherit nixpkgs-config overlay;
                flake = self;
                lib = import lib { pkgs = nixpkgs; };
              };
              _module.args.system = system;
            })
            hostfile
          ];
        };

      devShells = flake-utils.lib.eachDefaultSystem (
        system:
        let
          pkgs = import nixos-unstable {
            inherit system;

            config = import nixpkgs-config;

            overlays = [
              inputs.nur.overlays.default
              (import overlay)
            ];
          };

          stable-pkgs = import nixos-stable {
            inherit system;

            config = import nixpkgs-config;

            overlays = [
              inputs.nur.overlays.default
              (import overlay)
            ];
          };
        in
        {
          # Ensure the environment has git-crypt and a nix that can build flakes.
          devShell = with pkgs; mkShell {
            buildInputs =
              let
                # A script to open the NixOS manual for the nixos-unstable
                # commit currently in the flake.
                # This shouldn't be needed for stable, since stable doesn't
                # change much and so the manual on the Nix website should be up
                # to date.
                nixos-unstable-manual =
                  let
                    inherit (nixos-unstable.htmlDocs) nixosManual;

                    # The path to the manual index.
                    manualPath = "${nixosManual.x86_64-linux}/share/doc/nixos/index.html";
                  in
                  pkgs.writeShellScriptBin "nixos-unstable-manual" ''
                    if [ ! -z "$BROWSER" ]
                    then
                      # Open the manual index in the browser in the environment.
                      exec "$BROWSER" "${manualPath}"
                    else
                      # Don't try to find a backup browser, just dump the index
                      # of the manual.
                      echo "\\$BROWSER not specified"
                      echo "NixOS manual index: ${manualPath}"
                    fi
                  '';
              in
              [
                gitAndTools.git-crypt
                nix-output-monitor
                nixos-unstable-manual
                stable-pkgs.nur.repos.rycee.mozilla-addons-to-nix
              ];

            # Make sure nix knows to enable flakes.
            NIX_CONFIG = "experimental-features = nix-command flakes";
          };
        }
      );
    in
    {
      homeConfigurations = {
        "iamthememory@nightmare" = mkHost { host = "nightmare"; };
      };

      nixosConfigurations = {
        nightmare = mkOSHost { host = "nightmare"; };
      };
    } // devShells;
}
