{
  description = "iamthememory's dotfiles and setup";

  inputs = {
    # Nix packages.
    nixos-stable.url = "github:NixOS/nixpkgs/nixos-20.09";
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

    # i3status-rust.
    # FIXME: Remove this and use the version in nixpkgs once
    # https://github.com/greshake/i3status-rust/pull/972
    # is in a released version.
    # FIXME: This is pinned since the commit changing block IDs to usize can
    # cause integer overflows in i3 when it tries to parse output if a block
    # outputs its ID.
    i3status-rust = {
      url = "github:greshake/i3status-rust/5564c9c131ec2c34d8ce15f7b5cd1edde6a47c33";
      flake = false;
    };

    # The latest cataclysm-dda.
    cataclysm-dda = {
      url = "github:CleverRaven/Cataclysm-DDA";
      flake = false;
    };

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
      url = "github:hugsy/gef/dev";
      flake = false;
    };

    # Extra scripts and structures for GEF.
    gef-extras = {
      url = "github:hugsy/gef-extras";
      flake = false;
    };

    # An assembler framework.
    keystone-engine = {
      url = "github:keystone-engine/keystone";
      flake = false;
    };

    # (Neo)vim plugins not in nixpkgs.

    vim-solarized8 = {
      url = "github:lifepillar/vim-solarized8";
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

    # WINE packages and patches not in nixpkgs.

    lutris-6_0 = {
      url = "github:lutris/wine/lutris-6.0";
      flake = false;
    };

    # A patched, more up-to-date tinyfugue.
    tinyfugue-patched = {
      url = "github:ingwarsw/tinyfugue";
      flake = false;
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
            "nixos-stable"
            "nixos-unstable"
            "nixpkgs-master"
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
              inputs.nur.overlay
              (import overlay)
            ];
          }).nur;

          importedInputs = unimportedInputs // {
            inherit unstable stable master nur nixpkgs-config overlay;

            hostname = host;

            flake = self;
            lib = import lib { inherit pkgs; };
            scripts = import scripts { inherit pkgs; };
          };
        in
        home-manager.lib.homeManagerConfiguration {
          configuration = {
            _module.args.inputs = importedInputs;

            imports = [
              hostfile
            ];
          };

          inherit username homeDirectory system pkgs;
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
              _module.args.inputs = defaultInputs;
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
              (import overlay)
            ];
          };
        in
        {
          # Ensure the environment has git-crypt and a nix that can build flakes.
          devShell = with pkgs; mkShell {
            buildInputs =
              let
                nixos-rebuild = pkgs.nixos-rebuild.override {
                  nix = nixFlakes;
                };

                # A script to open the NixOS manual for the nixos-unstable
                # commit currently in the flake.
                # This shouldn't be needed for stable, since stable doesn't
                # change much and so the manual on the Nix website should be up
                # to date.
                nixos-unstable-manual =
                  let
                    inherit (nixos-unstable.htmlDocs) nixosManual;

                    # The path to the manual index.
                    manualPath = "${nixosManual}/share/doc/nixos/index.html";
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
                nixFlakes
                nixos-rebuild
                nixos-unstable-manual
              ];

            # Make sure nix knows to enable flakes.
            NIX_CONFIG = "experimental-features = nix-command flakes";
          };
        }
      );
    in
    {
      homeManagerConfigurations = {
        nightmare = mkHost { host = "nightmare"; };
      };

      nixosConfigurations = {
        nightmare = mkOSHost { host = "nightmare"; };
      };
    } // devShells;
}
