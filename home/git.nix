# Configuration for git.
{ config
, inputs
, lib
, pkgs
, ...
}:
let
  # Add libsecret to gitFull, so that it can use things like gnome-keyring
  # for credentials.
  gitFull = pkgs.gitFull.override {
    withLibsecret = true;
  };

  inherit (lib) mkDefault;

  # The primary mail account if one exists.
  # If there is one, we set git's default name and email from it, making it
  # overrideable.
  # NOTE: There will be either 0 or 1 primary accounts, no more, due to
  # assertions home-manager makes.
  primary-mail =
    let
      # Return true if this is the primary account.
      filterPrimary = n: v: v.primary == true;

      # Make a list of the zero or one primary accounts.
      maybePrimary = builtins.attrValues
        (lib.filterAttrs filterPrimary config.accounts.email.accounts);

      primary =
        if (builtins.length maybePrimary) == 0 then
          { }
        else
          builtins.elemAt maybePrimary 0;
    in
    primary;
in
{
  imports = [
    # Ensure we have our gnupg config available.
    ./gnupg.nix
  ];

  # Add git-related tools and documentation.
  home.packages = with pkgs; [
    # A tool to transparently encrypt and decrypt files in a git repo.
    git-crypt

    # Additional convenient git tools.
    git-extras

    # A tool for helping with the git flow workflow.
    gitflow

    # A tool that adds commands to interact with GitHub from the terminal.
    # Mostly superseded by the newer GitHub CLI tool, but still used for older
    # scripts and (neo)vim plugins.
    hub
  ];

  # Enable the GitHub CLI tool.
  # NOTE: The sessionVariable GITHUB_TOKEN should be set to the GitHub token
  # for the particular host for authentication.
  programs.gh.enable = true;

  # Use gh for managing GitHub credentials.
  programs.gh.gitCredentialHelper.enable = true;

  # Use the default editor if available.
  programs.gh.settings.editor =
    mkDefault (config.home.sessionVariables.EDITOR or "");

  # Enable git.
  programs.git.enable = true;

  # Extra configuration options for git.
  programs.git.settings =
    let
      inherit (inputs.lib) defaultOrNull filterNullOrEmpty;
      inherit (lib) recursiveUpdate;

      # Since null values are invalid, rather than just excluded from the
      # configuration, only include these options if they have a valid setting.
      # We need to do this recursively.
      # NOTE: Replace this once I find a more elegant way to filter recursively
      # from the bottom up.
      optionalValues = filterNullOrEmpty {
        core = filterNullOrEmpty {
          # Use the same askpass as SSH_ASKPASS if set.
          askPass = defaultOrNull config.home.sessionVariables "SSH_ASKPASS";

          # Use the default editor if available.
          editor = defaultOrNull config.home.sessionVariables "EDITOR";
        };
      };
    in
    recursiveUpdate
      {
        # Git alias commands.
        alias =
          let
            # Show the log, ordered by date, and with a graph and some extra stat
            # info.
            logg = "log --date-order --graph --stat";
          in
          {
            inherit logg;

            # Show a log of all changes since the last pull/ref change, and their
            # patches.
            lastpatch = "${logg} -p @{1}..HEAD";

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
            serve =
              let
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
              in
              "!${config.programs.git.package}/bin/git daemon ${args} .git/";
          };

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

        # Use HTTPS when hub does GitHub operations.
        hub.protocol = "https";

        # Use main as the default branch name.
        init.defaultBranch = "main";

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

        # Rewrite any remotes like gh:user/repo to point to GitHub repos.
        url."https://github.com/" = {
          insteadOf = "gh:";
          pushInsteadOf = "gh:";
        };

        # Set the default git name and email to the primary account's name and email.
        # These should default to null if there is no primary account.
        # NOTE: These are overrideable.
        user.email = mkDefault (primary-mail.address or null);
        user.name = mkDefault (primary-mail.realName or null);
      }
      optionalValues;

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

    # Ignore nix-direnv's temporary directories.
    ".direnv"

    # Ignore result links from nix builds.
    "/result"
    "/result-doc"

    # Ignore (neo)vim session files.
    "Session.vim"
  ];

  # Enable git-lfs.
  programs.git.lfs.enable = true;

  # Use full-featured git, with libsecret enabled so that things like the
  # gnome-keyring can be used for credentials.
  programs.git.package = gitFull;

  # Use PGP commit signing.
  programs.git.signing.format = "openpgp";

  # If gnupg has a default key set, use it for signing git commits.
  # NOTE: This is overrideable if a host should have a separate signing
  # (sub)key for git for some reason.
  programs.git.signing.key = mkDefault
    (config.programs.gpg.settings.default-key or null);

  # Sign commits by default.
  programs.git.signing.signByDefault = true;
}
