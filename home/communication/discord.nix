# Discord-related configuration.
{ config
, pkgs
, ...
}:
let
  # The binary directory of the current profile.
  profileBin = "${config.home.profileDirectory}/bin";
in
{
  home.packages = with pkgs;
    let
      # A Discord wrapper to enable text-to-speech and restart it if it dies, as
      # well as dumping its output to a log.
      discordWrapper =
        let
          # Tools in the current profile.
          chmod = "${profileBin}/chmod";
          discord = "${profileBin}/Discord";
          id = "${profileBin}/id";
          sleep = "${profileBin}/sleep";
          tee = "${profileBin}/tee";
          touch = "${profileBin}/touch";

          # The location of the log file to use.
          logFile = "/tmp/discord.log.$(\"${id}\" --real --user)";
        in
        pkgs.writeShellScriptBin "discord.sh" ''
          # If something goes wrong, die.
          set -euo pipefail

          # Create and set the log file permissions.
          "${touch}" "${logFile}"
          "${chmod}" 600 "${logFile}"

          while true
          do
            # Run Discord.
            "${discord}" --enable-speech-dispatcher --multi-instance --disable-renderer-backgrounding 2>&1 \
              | "${tee}" -a "${logFile}" \
              || true

            # Sleep a second to make it easier to kill this script.
            "${sleep}" 5
          done
        '';

      discord = pkgs.discord.override {
        # A Discord client mod.
        withVencord = false;
      };
    in
    [
      # Ensure coreutils is available.
      coreutils

      # The Discord client.
      discord

      # A dumb wrapper for Discord to restart it if killed.
      discordWrapper
    ];

  # Start Discord on startup.
  xsession.windowManager.i3.config.startup = [
    { command = "${profileBin}/discord.sh"; }
  ];

  # Handle Discord URLs with Discord.
  xdg.mimeApps.defaultApplications."x-scheme-handler/discord" =
    "discord.desktop";
}
