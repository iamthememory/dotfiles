{
  description = "iamthememory's dotfiles and setup";

  inputs = {
    # Nix packages.
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-20.09";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";

    # The Nix user repository overlay.
    nur.url = "github:nix-community/NUR";

    # Home-manager.
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    # Various flake utilities.
    flake-utils.url = "github:numtide/flake-utils";

    # Solarized LS_COLORS.
    dircolors-solarized = {
      url = "github:seebi/dircolors-solarized";
      flake = false;
    };

    # (Neo)vim plugins.

    direnv-vim = {
      url = "github:direnv/direnv.vim";
      flake = false;
    };

    editorconfig-vim = {
      url = "github:editorconfig/editorconfig-vim";
      flake = false;
    };

    fzf = {
      url = "github:junegunn/fzf";
      flake = false;
    };

    fzf-vim = {
      url = "github:junegunn/fzf.vim";
      flake = false;
    };

    git-messenger = {
      url = "github:rhysd/git-messenger.vim";
      flake = false;
    };

    gundo-vim = {
      url = "github:sjl/gundo.vim";
      flake = false;
    };

    gv = {
      url = "github:junegunn/gv.vim";
      flake = false;
    };

    nerdtree = {
      url = "github:preservim/nerdtree";
      flake = false;
    };

    nerdtree-git-plugin = {
      url = "github:Xuyuanp/nerdtree-git-plugin";
      flake = false;
    };

    recover-vim = {
      url = "github:chrisbra/Recover.vim";
      flake = false;
    };

    tabular = {
      url = "github:godlygeek/tabular";
      flake = false;
    };

    vim-abolish = {
      url = "github:tpope/vim-abolish";
      flake = false;
    };

    vim-airline = {
      url = "github:vim-airline/vim-airline";
      flake = false;
    };

    vim-airline-themes = {
      url = "github:vim-airline/vim-airline-themes";
      flake = false;
    };

    vim-commentary = {
      url = "github:tpope/vim-commentary";
      flake = false;
    };

    vim-devicons = {
      url = "github:ryanoasis/vim-devicons";
      flake = false;
    };

    vim-dispatch = {
      url = "github:tpope/vim-dispatch";
      flake = false;
    };

    vim-easymotion = {
      url = "github:easymotion/vim-easymotion";
      flake = false;
    };

    vim-eunuch = {
      url = "github:tpope/vim-eunuch";
      flake = false;
    };

    vim-fugitive = {
      url = "github:tpope/vim-fugitive";
      flake = false;
    };

    vim-gist = {
      url = "github:mattn/vim-gist";
      flake = false;
    };

    vim-gitgutter = {
      url = "github:airblade/vim-gitgutter";
      flake = false;
    };

    vim-github-dashboard = {
      url = "github:junegunn/vim-github-dashboard";
      flake = false;
    };

    vim-obsession = {
      url = "github:tpope/vim-obsession";
      flake = false;
    };

    vim-polyglot = {
      url = "github:sheerun/vim-polyglot";
      flake = false;
    };

    vim-repeat = {
      url = "github:tpope/vim-repeat";
      flake = false;
    };

    vim-rhubarb = {
      url = "github:tpope/vim-rhubarb";
      flake = false;
    };

    vim-sensible = {
      url = "github:tpope/vim-sensible";
      flake = false;
    };

    vim-solarized8 = {
      url = "github:lifepillar/vim-solarized8";
      flake = false;
    };

    vim-speeddating = {
      url = "github:tpope/vim-speeddating";
      flake = false;
    };

    vim-surround = {
      url = "github:tpope/vim-surround";
      flake = false;
    };

    vim-unimpaired = {
      url = "github:tpope/vim-unimpaired";
      flake = false;
    };

    webapi = {
      url = "github:mattn/webapi-vim";
      flake = false;
    };

    # ZSH plugins.

    fast-syntax-highlighting = {
      url = "github:zdharma/fast-syntax-highlighting";
      flake = false;
    };

    powerlevel10k = {
      url = "github:romkatv/powerlevel10k";
      flake = false;
    };

    web-search = {
      url = "github:sinetoami/web-search";
      flake = false;
    };

    zsh-async = {
      url = "github:mafredri/zsh-async";
      flake = false;
    };

    zsh-auto-notify = {
      url = "github:MichaelAquilina/zsh-auto-notify";
      flake = false;
    };

    zsh-sudo = {
      url = "github:hcgraf/zsh-sudo";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs-stable,
    nixpkgs-unstable,
    nixpkgs-master,
    home-manager,
    flake-utils,
    ...
  }@inputs: let
    defaultInputs = let
      # Exclude self and the un-initialized nixpkgs when passing inputs to
      # home-manager.
      blacklist = [
        "self"
        "nixpkgs-stable"
        "nixpkgs-unstable"
        "nixpkgs-master"
        "nur"
      ];

      notBlacklisted = n: v: !(builtins.elem n blacklist);
    in nixpkgs-stable.lib.filterAttrs notBlacklisted inputs;

    hosts = [
      "nightmare"
    ];

    lib = ./lib;

    overlay = ./overlay.refactor;

    scripts = ./scripts.refactor;

    nixpkgs-config = ./config.nix;

    mkHost = {
      host,
      username ? "iamthememory",
      homeDirectory ? "/home/${username}",
      system ? "x86_64-linux",
      unimportedInputs ? defaultInputs,
      nixpkgs ? nixpkgs-unstable,
    }: let
      hostfile = ./home.refactor/hosts + "/${host}";

      importPkgs = p: import p {
        inherit system;

        config = import nixpkgs-config;

        overlays = [
          (import overlay)
        ];
      };

      pkgs = importPkgs nixpkgs;
      unstable = importPkgs nixpkgs-unstable;
      stable = importPkgs nixpkgs-stable;
      master = importPkgs nixpkgs-master;

      nur = import nixpkgs {
        inherit system;

        config = import nixpkgs-config;

        overlays = [
          inputs.nur.overlay
          (import overlay)
        ];
      };

      importedInputs = unimportedInputs // {
        inherit unstable stable master nur nixpkgs-config overlay;

        lib = import lib { inherit pkgs; };
        scripts = import scripts { inherit pkgs; };
      };
    in home-manager.lib.homeManagerConfiguration {
      configuration = {
        _module.args.inputs = importedInputs;

        imports = [
          hostfile
        ];
      };

      inherit username homeDirectory system pkgs;
    };

    devShells = flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs-unstable {
          inherit system;

          config = import nixpkgs-config;

          overlays = [
            (import overlay)
          ];
        };
      in {
        # Ensure the environment has git-crypt and a nix that can build flakes.
        devShell = with pkgs; mkShell {
          buildInputs = [
            gitAndTools.git-crypt
            nixFlakes
          ];

          # Make sure nix knows to enable flakes.
          NIX_CONFIG = "experimental-features = nix-command flakes";
        };
      }
    );
  in {
    homeManagerConfigurations = {
      nightmare = mkHost { host = "nightmare"; };
    };
  } // devShells;
}
