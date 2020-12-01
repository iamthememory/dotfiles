# Configuration for git.
{
  config,
  pkgs,
  ...
}: let
  # Add libsecret to gitFull, so that it can use things like gnome-keyring
  # for credentials.
  gitFull = pkgs.gitAndTools.gitFull.override {
    withLibsecret = true;
  };

  inherit (pkgs.lib) mkDefault;

  # The primary mail account if one exists.
  # If there is one, we set git's default name and email from it, making it
  # overrideable.
  # NOTE: There will be either 0 or 1 primary accounts, no more, due to
  # assertions home-manager makes.
  primary-mail = let
    inherit (pkgs) lib;

    # Return true if this is the primary account.
    filterPrimary = n: v: v.primary == true;

    # Make a list of the zero or one primary accounts.
    maybePrimary = builtins.attrValues
      (lib.filterAttrs filterPrimary config.accounts.email.accounts);

    primary =
      if (builtins.length maybePrimary) == 0 then
        {}
      else
        builtins.elemAt maybePrimary 0;
  in primary;
in {
  # Add git-related tools and documentation.
  home.packages = with pkgs; [
  ];

  # Enable the GitHub CLI tool.
  # NOTE: The sessionVariable GITHUB_TOKEN should be set to the GitHub token
  # for the particular host for authentication.
  programs.gh.enable = true;

  # Use the default editor if available.
  programs.gh.editor = mkDefault (config.home.sessionVariables.EDITOR or "");

  # Enable git.
  programs.git.enable = true;

  # Git alias commands.
  programs.git.aliases = let
    # Show the log, ordered by date, and with a graph and some extra stat
    # info.
    logg = "log --date-order --graph --stat";
  in {
    inherit logg;

    # logg, but show PGP signatures too.
    loggs = "${logg} --show-signature";

    # logg, but show all commits, not just those reachable from the current
    # HEAD.
    logga = "${logg} --all";

    # logga and loggs combined.
    loggas = "${logg} --all --show-signature";

    # Show the absolute path of the top-level directory of the repo we're
    # in.
    root = "rev-parse --show-toplevel";

    # Serve the local repo quickly on the network for ad hoc sharing.
    # NOTE: This uses ! as a prefix to make this a shell command, since all
    # shell aliases are run directly in the top-level of the repository,
    # simplifying things.
    serve = let
      args = builtins.concatStringsSep " " [
        # Serve from the top-level .git directory, rather than the working
        # tree.
        "--base-path=.git"

        # Export the repository, even if not marked as a repo that should be
        # exported, since this is for ad-hoc sharing without much setup.
        "--export-all"

        # Reuse the address without waiting for old connections to timeout.
        "--reuseaddr"

        # Strictly match paths, and don't allow access to any directories not
        # specified.
        "--strict-paths"

        # Show all connections, since this'll probably be used for ad-hoc
        # sharing then killed, so this makes it easy to see when it finishes.
        "--verbose"
      ];
    in "!${config.programs.git.package}/bin/git daemon ${args} .git/";
  };

  # Extra configuration options for git.
  programs.git.extraConfig = let
    # True for non-null values.
    notNullOrEmpty = n: v: v != null && v != {};

    inherit (pkgs.lib) filterAttrs recursiveUpdate;

    # mkDefault set.attr if attr is an attribute of set, otherwise null.
    defaultOrNull = set: attr:
      if builtins.hasAttr attr set then
        mkDefault (builtins.getAttr attr set)
      else
        null;

    # Since null values are invalid, rather than just excluded from the
    # configuration, only include these options if they have a valid setting.
    optionalValues = filterAttrs notNullOrEmpty {
      # Remove non-null/empty attributes here, too, so that the total
      # optionalValues set is empty if these are all empty.
      core = filterAttrs notNullOrEmpty {
        # Use the same askpass as SSH_ASKPASS if set.
        askPass = defaultOrNull config.home.sessionVariables "SSH_ASKPASS";

        # Use the default editor if available.
        editor = defaultOrNull config.home.sessionVariables "EDITOR";
      };
    };
  in recursiveUpdate {
    # Use color if available.
    color.ui = "auto";

    # Use longer default commit abbreviations.
    core.abbrev = 12;

    # Use the default $PAGER, or less if unset.
    core.pager = mkDefault
      (config.home.sessionVariables.PAGER or "${pkgs.less}/bin/less");

    # Use libsecret for credentials by default.
    credential.helper = mkDefault "libsecret";

    # Remove any remote tracking refs that no longer exist on remotes.
    fetch.prune = true;

    # When merging, create an explicit merge commit, rather than
    # fast-forwarding.
    merge.ff = false;

    # Only allow fast-forward pulls, rather than merging upstream.
    # Merges should be explicit actions.
    pull.ff = "only";

    # Push to the upstream tracking branch of the same name.
    push.default = "simple";

    # If the server supports it, sign "git push"es with gpg.
    push.gpgsign = "if-asked";

    # Recurse into submodules with commands like fetch, pull, push by default.
    submodule.recurse = true;
  } optionalValues;

  # Paths that should always be ignored.
  programs.git.ignores = [
    # Ignore vim-like temporary files.
    ".*.sw[nop]"

    # Don't commit ctags files.
    ".ctags"
    ".ctags.lock"
    ".ctags.temp"
    "tags"
    "tags.lock"
    "tags.temp"
  ];

  # Enable git-lfs.
  programs.git.lfs.enable = true;

  # Use full-featured git, with libsecret enabled so that things like the
  # gnome-keyring can be used for credentials.
  programs.git.package = gitFull;

  # If gnupg has a default key set, use it for signing git commits.
  # NOTE: This is overrideable if a host should have a separate signing
  # (sub)key for git for some reason.
  programs.git.signing.key = mkDefault
    (config.programs.gpg.settings.default-key or null);

  # Sign commits by default.
  programs.git.signing.signByDefault = true;

  # Set the default git name and email to the primary account's name and email.
  # These should default to null if there is no primary account.
  # NOTE: These are overrideable.
  programs.git.userEmail = mkDefault (primary-mail.address or null);
  programs.git.userName = mkDefault (primary-mail.realName or null);
}
