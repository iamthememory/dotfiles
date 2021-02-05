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
  # The portion of the script that scrapes for the index matching this revision
  # of nixpkgs.
  # This is kept separate so it can be used both on generation activation if
  # the nixpkgs revision has changed, and so that it can be used periodically
  # to update for any packages that may not have been built in hydra yet when
  # the generation was activated.
  updateNixIndex = "${pkgs.nix-index}/bin/nix-index -f '${pkgs.path}'";

  # Where the link to the nixpkgs revision used to generate the nix-index
  # should go.
  nixIndexRevisionLink = "${config.xdg.cacheHome}/nix-index/nixpkgs-tree";

  # A short variable for invoking realpath to make the scripts easier to write.
  # This should follow and canonicalize a symlink to its real, absolute path.
  realpath = "${pkgs.coreutils}/bin/realpath -e";
in
{
  home.packages = with pkgs; [
    # Install nix-index so nix-locate can be called.
    nix-index
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
      $DRY_RUN_CMD ${pkgs.coreutils}/bin/rm -f "${nixIndexRevisionLink}"
      $DRY_RUN_CMD ${pkgs.coreutils}/bin/ln -s "${pkgs.path}" "${nixIndexRevisionLink}"
    fi

    unset HM_DO_NIX_INDEX_UPDATE
  '';

  # Handle commands that aren't found with nix-index, showing what packages
  # provide them.
  # NOTE: These won't have an effect unless bash/zsh are enabled too.
  # (We disable the regular command-not-found as well.)
  programs.command-not-found.enable = false;
  programs.bash.initExtra = ''
    source ${pkgs.nix-index}/etc/profile.d/command-not-found.sh
  '';
  programs.zsh.initExtra = ''
    source ${pkgs.nix-index}/etc/profile.d/command-not-found.sh
  '';

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
            ${pkgs.coreutils}/bin/rm -f "${nixIndexRevisionLink}"
            ${pkgs.coreutils}/bin/ln -s "${pkgs.path}" "${nixIndexRevisionLink}"
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
