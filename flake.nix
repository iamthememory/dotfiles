{
  description = "iamthememory's dotfiles and setup";

  inputs = {
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-20.09";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    zsh-async = {
      url = "github:mafredri/zsh-async";
      flake = false;
    };

    zsh-auto-notify = {
      url = "github:MichaelAquilina/zsh-auto-notify";
      flake = false;
    };

    zsh-fast-syntax-highlighting = {
      url = "github:zdharma/fast-syntax-highlighting";
      flake = false;
    };

    zsh-powerlevel10k = {
      url = "github:romkatv/powerlevel10k";
      flake = false;
    };

    zsh-sudo = {
      url = "github:hcgraf/zsh-sudo";
      flake = false;
    };

    zsh-web-search = {
      url = "github:sinetoami/web-search";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs-stable,
    nixpkgs-unstable,
    nixpkgs-master,
    home-manager,
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
      ];

      notBlacklisted = n: v: !(builtins.elem n blacklist);
    in nixpkgs-stable.lib.filterAttrs notBlacklisted inputs;

    hosts = [
      "nightmare"
    ];

    scripts = ./scripts.refactor;

    mkHost = {
      host,
      username ? "iamthememory",
      homeDirectory ? "/home/${username}",
      system ? "x86_64-linux",
      unimportedInputs ? defaultInputs,
      nixpkgs ? nixpkgs-unstable,
    }: let
      hostfile = ./home.refactor/hosts + "/${host}";

      importPkgs = p: import p { inherit system; };

      pkgs = importPkgs nixpkgs;
      unstable = importPkgs nixpkgs-unstable;
      stable = importPkgs nixpkgs-stable;
      master = importPkgs nixpkgs-master;

      importedInputs = unimportedInputs // {
        inherit unstable stable master;

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
  in {
    homeManagerConfigurations = {
      nightmare = mkHost { host = "nightmare"; };
    };
  };
}
