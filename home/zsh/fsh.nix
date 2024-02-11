# Configuration for fast-syntax-highlighting, ZSH syntax highlighting in the
# shell.
{ config
, lib
, pkgs
, ...
}: {
  programs.zsh.initExtra = ''
    # Use the default theme.
    fast-theme -q default
  '';

  # Add fast-syntax-highlighting to ZSH.
  programs.zsh.plugins = [{
    name = "fast-syntax-highlighting";
    src = "${pkgs.zsh-fast-syntax-highlighting}/share/zsh/site-functions";
    file = "fast-syntax-highlighting.plugin.zsh";
  }];

  # Use ~/.cache/fsh for FSH's working directory.
  programs.zsh.sessionVariables.FAST_WORK_DIR =
    let
      inherit (config.xdg) cacheHome;
    in
    "${cacheHome}/fsh";

  # Ensure ~/.cache/fsh exists.
  home.activation.createFastSyntaxHighlightingCache =
    let
      inherit (config.programs.zsh.sessionVariables) FAST_WORK_DIR;
    in
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      if [ -e "${FAST_WORK_DIR}" ]
      then
        if [ -d "${FAST_WORK_DIR}" ] && [ -w "${FAST_WORK_DIR}" ]
        then
          $VERBOSE_ECHO "FSH working directory exists and is writeable: ${FAST_WORK_DIR}"
        else
          errorEcho "FSH working directory (${FAST_WORK_DIR}) must be a writeable directory"
          exit 1
        fi
      else
        $VERBOSE_ECHO "Creating FSH working directory: ${FAST_WORK_DIR}"
        run ${pkgs.coreutils}/bin/mkdir -p $VERBOSE_ARG "${FAST_WORK_DIR}"
      fi
    '';
}
