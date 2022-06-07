# Configuration for the GameMode daemon.
{ ...
}: {
  # Enable the GameMode daemon for modifying priorities, etc. of running
  # games.
  programs.gamemode.enable = true;
}
