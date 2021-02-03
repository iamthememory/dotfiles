# The configuration for pet, a terminal command snippet manager.
{ config
, inputs
, lib
, ...
}: {
  # Enable pet.
  programs.pet.enable = true;

  # Pet settings.
  programs.pet.settings =
    let
      inherit (inputs.lib) filterNullOrEmpty defaultOrNull;
      inherit (lib) recursiveUpdate;

      # It's invalid to have any of these as null, so remove them entirely if
      # null.
      optionalValues = filterNullOrEmpty {
        General = filterNullOrEmpty {
          # Use the default editor if available.
          editor = defaultOrNull config.home.sessionVariables "EDITOR";
        };
      };
    in
    recursiveUpdate
      {
        # Use fzf for selections.
        General.selectcmd = "${config.home.profileDirectory}/bin/fzf";
      }
      optionalValues;

  # Pet snippets.
  programs.pet.snippets = [
    {
      command = "cd ~/dotfiles && nix build \".#homeManagerConfigurations.$(hostname).activationPackage\" && ./result/activate";
      description = "Build and activate a new home-manager generation for the current host";
    }
    {
      command =
        let
          listInputs = "nix flake list-inputs --json <flake=.>";

          getLockedRepos = ".nodes | to_entries | map(select(.key != \"root\")) | map(.value.locked)";
          toScript = ''map("if [ ! -e \"\(.repo)\" ]\nthen\n  pushd \"<clonebase>\" \\\n  && git clone \"https://github.com/\(.owner)/\(.repo).git\" \\\n  && cd \"\(.repo)\" \\\n  && git checkout \"\(.rev)\" \\\n  && popd\nfi")'';
          jq = ''jq --raw-output '${getLockedRepos} | ${toScript} | join("\n\n")' '';

          scriptInit = ''echo -ne '#!/usr/bin/env bash\nset -euo pipefail\nmkdir -pv "<clonebase>"\n\n' '';
        in
        "__PET_CLONESCRIPT=\"<clonescript=/tmp/clone-flake-inputs.sh>\" && ( ${scriptInit} && ${listInputs} | ${jq}; ) | tee \"$__PET_CLONESCRIPT\" && chmod +x \"$__PET_CLONESCRIPT\" && unset __PET_CLONESCRIPT";
      description = "Clone the inputs for a nix flake";
    }
  ];
}
