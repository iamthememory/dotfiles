{
  description = "iamthememory's dotfiles and setup";

  inputs = {
    # Nix packages.
    nixos-stable.url = "github:NixOS/nixpkgs/nixos-22.05";
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

    # The latest upstream picom.
    # FIXME: This can be removed once they release a version with changes that
    # fix the weird flickering bug.
    picom = {
      url = "github:yshui/picom/next";
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
      url = "github:hugsy/gef-extras/dev";
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

          # A minimal recovery ISO.
          recoverySystem = nixpkgs.lib.nixosSystem {
            inherit system;

            modules = [{
              imports = [
                "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
              ];

              # Ensure the stage 1 initrd has LUKS support in case it's needed.
              # This won't make the stage 1 boot script handle LUKS on its own,
              # but it will ensure the LUKS tools are available.
              boot.initrd.luks.forceLuksSupportInInitrd = true;

              # Ensure the stage 1 initrd has enough filesystem support to find
              # its ISO on whatever /boot is likely to be, if, e.g., /boot is
              # ext4 and the ISO's in /boot/iso/nixos-minimal.iso.
              boot.initrd.supportedFilesystems = [
                # Support bcachefs.
                "bcachefs"

                # Support btrfs.
                "btrfs"

                # Support the ext family.
                "ext2"
                "ext3"
                "ext4"

                # Support FAT filesystems.
                "exfat"
                "vfat"

                # Support ZFS.
                "zfs"
              ];
            }];
          };

          recoveryISO = recoverySystem.config.system.build.isoImage;
        in
        nixpkgs.lib.nixosSystem {
          inherit system;

          modules = [
            ({
              _module.args.inputs = defaultInputs // {
                inherit nixpkgs-config overlay recoveryISO;
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
              inputs.nur.overlay
              (import overlay)
            ];
          };

          stable-pkgs = import nixos-stable {
            inherit system;

            config = import nixpkgs-config;

            overlays = [
              inputs.nur.overlay
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
                nixos-unstable-manual
                stable-pkgs.nur.repos.rycee.firefox-addons-generator
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
