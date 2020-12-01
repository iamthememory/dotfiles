# The configuration for pet, a terminal command snippet manager.
{
  config,
  inputs,
  pkgs,
  ...
}: {
  # Enable pet.
  programs.pet.enable = true;

  # Pet settings.
  programs.pet.settings = let
    inherit (inputs.lib) filterNullOrEmpty defaultOrNull;
    inherit (pkgs.lib) recursiveUpdate;

    # It's invalid to have any of these as null, so remove them entirely if
    # null.
    optionalValues = filterNullOrEmpty {
      General = filterNullOrEmpty {
        # Use the default editor if available.
        editor = defaultOrNull config.home.sessionVariables "EDITOR";
      };
    };
  in recursiveUpdate {
    # Use fzf for selections.
    General.selectcmd = "${pkgs.fzf}/bin/fzf";
  } optionalValues;

  # Pet snippets.
  programs.pet.snippets = [
    {
      command = "cd ~/dotfiles && nix build \".#homeManagerConfigurations.$(hostname).activationPackage\" && ./result/activate";
      description = "Build and activate a new home-manager generation for the current host";
    }
  ];
}
