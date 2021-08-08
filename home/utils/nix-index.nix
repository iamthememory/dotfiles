# Configuration for nix-index, a tool for scraping hydra to build an index of
# what packages provide what files, to search for binaries or other files when
# the package isn't known.
# It can also handle when commands aren't found when typed in a shell.
{ config
, lib
, pkgs
, ...
}:
let
  # Where the link to the nixpkgs revision used to generate the nix-index
  # should go.
  nixIndexRevisionLink = "${config.xdg.cacheHome}/nix-index/nixpkgs-tree";

  # A short variable for invoking realpath to make the scripts easier to write.
  # This should follow and canonicalize a symlink to its real, absolute path.
  realpath = "${pkgs.coreutils}/bin/realpath -e";

  # A script to run nix-index and update the symlink.
  updateNixIndexPkg = pkgs.writeShellScriptBin "update-nix-index.sh" ''
    # Die on any errors.
    set -euo pipefail

    # Make a temporary directory to hold any file listings that failed to parse.
    # This is so we can remove them after running nix-index, because they can
    # add up over time to literal gigabytes in some cases, which ends up taking
    # up RAM since /tmp is usually a tmpfs.
    export TMPDIR="$(${pkgs.coreutils}/bin/mktemp -d /tmp/nix-index.XXXXXXXXXXXXXXXX)"
    export TMP="$TMPDIR"

    # Clear the directory when the script dies or exits.
    cleanup() {
      ${pkgs.coreutils}/bin/rm -rf "$TMPDIR"
    }
    trap cleanup EXIT INT TERM

    # Update the nix index using the packages for this generation.
    # We use pkgs.path here so that it will always choose the packages for the
    # generation that this script is part of, so it always does the same thing,
    # whether called as part of the generation activation or the update timer.
    ${pkgs.nix-index}/bin/nix-index -f '${pkgs.path}'

    # Replace the revision link with a link to the pkgs we just used.
    ${pkgs.coreutils}/bin/rm -f "${nixIndexRevisionLink}"
    ${pkgs.coreutils}/bin/ln -s "${pkgs.path}" "${nixIndexRevisionLink}"
  '';

  updateNixIndex = "${updateNixIndexPkg}/bin/update-nix-index.sh";
in
{
  home.packages = with pkgs; [
    # Install nix-index so nix-locate can be called.
    nix-index

    # Install the wrapper to run nix-index on the current packages manually.
    updateNixIndexPkg
  ];

  # Update the nix-index cache on generation activation if we have a new
  # nixpkgs revision.
  home.activation.updateNixIndexCache = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    HM_DO_NIX_INDEX_UPDATE=0

    if [ ! -L "${nixIndexRevisionLink}" ]
    then
      $VERBOSE_ECHO "nix-index nixpkgs revision link missing or not a symlink: Updating nix-index"
      HM_DO_NIX_INDEX_UPDATE=1
    elif ! ${realpath} -q "${nixIndexRevisionLink}" >/dev/null
    then
      $VERBOSE_ECHO "nix-index nixpkgs revision symlink broken: Updating nix-index"
      HM_DO_NIX_INDEX_UPDATE=1
    elif [ "$(${realpath} "${nixIndexRevisionLink}")" != "$(${realpath} "${pkgs.path}")" ]
    then
      $VERBOSE_ECHO "nix-index nixpkgs revision doesn't match this generation: Updating nix-index"
      HM_DO_NIX_INDEX_UPDATE=1
    else
      $VERBOSE_ECHO "nix-index nixpkgs revision matches this generation: Not updating nix-index"
    fi

    if [ "$HM_DO_NIX_INDEX_UPDATE" = "1" ]
    then
      $DRY_RUN_CMD ${updateNixIndex}
    fi

    unset HM_DO_NIX_INDEX_UPDATE
  '';

  # Handle commands that aren't found with nix-index, showing what packages
  # provide them.
  programs.nix-index.enable = true;

  # Update the nix-index cache.
  systemd.user.services.update-nix-index-cache = {
    Unit.Description = "Update the nix-index database cache";

    Service = {
      Type = "oneshot";
      ExecStart =
        let
          update-index = pkgs.writeShellScript "update-nix-index.sh" ''
            set -eu
            set -o pipefail

            # Discard stderr, since nix-index will write progress info even when
            # not connected to a terminal, flooding the journal.
            ${updateNixIndex} 2>/dev/null
          '';
        in
        "${update-index}";
    };
  };

  # Update the nix-index cache weekly.
  systemd.user.timers.update-nix-index-cache = {
    Unit.Description = "Update the nix-index database cache";

    Timer = {
      OnCalendar = "weekly";
      RandomizedDelaySec = 600;
    };

    Install.WantedBy = [
      "timers.target"
    ];
  };
}
