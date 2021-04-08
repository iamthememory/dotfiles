# User configuration for nightmare.
# NOTE: Most of these group IDs are specified manually for compatibility with
# pre-existing configuration and files.
{ pkgs
, ...
}: {
  # A group for the music in /data/music.
  users.groups.music.gid = 618;

  # The plugdev group.
  users.groups.plugdev.gid = 619;

  # My user's group.
  users.groups.iamthememory.gid = 1000;

  # A games group.
  # NOTE: This may not be normally used on NixOS but is kept here for
  # compatibility with existing configuration.
  users.groups.games.gid = 1001;

  # A group for the sources in /data/src.
  users.groups.src.gid = 1007;

  # A group for the downloads in /data/downloads.
  users.groups.downloads.gid = 1008;

  # A group for the ebooks in /data/ebook.
  users.groups.ebook.gid = 1009;

  # A group for /data/tv.
  # NOTE: This doesn't seem to be used anymore and can probably be removed.
  users.groups.tv.gid = 1010;

  # A group for /data/movies.
  # NOTE: This doesn't seem to be used anymore and can probably be removed.
  users.groups.movies.gid = 1011;

  # Groups to add to my user.
  users.users.iamthememory.extraGroups = [
    # Permissions to use adb to connect to Android phones.
    "adbusers"

    # Permissions for audio access and audio-related realtime permissions.
    "audio"

    # Permissions to access cd hardware, if applicable.
    "cdrom"

    # Permissions to use CD-RW hardware, if applicable.
    # NOTE: This may not actually exist as a group but is kept for now.
    "cdrw"

    # Permissions to use cron.
    # NOTE: This may not be relevant anymore.
    "cron"

    # Permissions to access modems and similar.
    "dialout"

    # Permissions to access docker.
    "docker"

    # Permissions for /data/downloads.
    "downloads"

    # Permissions for /data/ebook.
    "ebook"

    # Permissions for games.
    # NOTE: This may not be normally used on NixOS but is kept for
    # compatibility.
    "games"

    # Permissions to access input devices.
    "input"

    # Permissions to access a running JACK server.
    # NOTE: This is no longer used but kept for compatibility.
    "jackaudio"

    # Permissions to access libvirtd.
    "libvirtd"

    # Permissions for /data/movies.
    "movies"

    # Permissions for /data/music.
    "music"

    # Permissions to access and change NetworkManager settings.
    "networkmanager"

    # Permissions to access removable devices.
    "plugdev"

    # Permissions for /data/src.
    "src"

    # Permissions to read the systemd journal.
    "systemd-journal"

    # Permissions to access ttys for direct writing.
    # NOTE: This may not be a good permission to give to a user.
    "tty"

    # Permissions for /data/tv.
    "tv"

    # Permissions to access USB devices.
    "usb"

    # A signifier that this is a real user.
    "users"

    # Permissions for some kinds of modems.
    "uucp"

    # Permissions for X11 and/or webcams.
    "video"

    # Permissions for sudo and admin privileges.
    "wheel"

    # Permissions to run wireshark.
    "wireshark"
  ];

  # Use a specific primary group for my user.
  users.users.iamthememory.group = "iamthememory";

  # Set my user as a normal user.
  users.users.iamthememory.isNormalUser = true;

  # Use ZSH as my default shell.
  users.users.iamthememory.shell = pkgs.zsh;

  # Use 1000 as my UID.
  users.users.iamthememory.uid = 1000;
}
