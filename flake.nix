{
  description = "iamthememory's dotfiles and setup";

  inputs = {
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-20.09";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = {
    self,
    nixpkgs-stable,
    nixpkgs-unstable,
    home-manager,
  }@inputs: let
    hosts = [
      "nightmare"
    ];

    defaultInputs = {
    };

    mkHost = {
      host,
      username ? "iamthememory",
      homeDirectory ? "/home/${username}",
      system ? "x86_64-linux",
      unimportedInputs ? defaultInputs,
      nixpkgs ? nixpkgs-unstable,
    }: let
      hostfile = ./home.refactor/hosts + "/${host}.nix";

      importPkgs = p: import p { inherit system; };

      pkgs = importPkgs nixpkgs;
      unstable = importPkgs nixpkgs-unstable;
      stable = importPkgs nixpkgs-stable;

      importedInputs = unimportedInputs // {
        inherit unstable stable;
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
