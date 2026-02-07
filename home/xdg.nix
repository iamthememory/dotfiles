# Set the values for the XDG directories.
{ config
, ...
}:
let
  inherit (config.home) homeDirectory;
in
{
  # Manage the basic xdg directories.
  xdg.enable = true;

  # The local cache directory.
  xdg.cacheHome = "${homeDirectory}/.cache";

  # The local config directoriy.
  xdg.configHome = "${homeDirectory}/.config";

  # The local data directory.
  xdg.dataHome = "${homeDirectory}/.local/share";

  # Manage the desktop-oriented xdg directories.
  # NOTE: home-manager at least currently doesn't add sessionVariables for
  # these like it does with the basic xdg directories.
  xdg.userDirs.enable = true;

  # Create any directories which are missing.
  xdg.userDirs.createDirectories = true;

  xdg.userDirs.desktop = "${homeDirectory}";
  xdg.userDirs.documents = "${homeDirectory}/src";
  xdg.userDirs.download = "${homeDirectory}/Downloads";
  xdg.userDirs.music = "${homeDirectory}/Music";
  xdg.userDirs.pictures = "${homeDirectory}";
  xdg.userDirs.publicShare = "${homeDirectory}";
  xdg.userDirs.templates = "${homeDirectory}";
  xdg.userDirs.videos = "${homeDirectory}";

  xdg.userDirs.extraConfig.MAIL = "${homeDirectory}/Mail";

  xdg.userDirs.setSessionVariables = true;

  # Add the xdg locale file, installed/used by xdg-user-dirs.
  xdg.configFile."user-dirs.locale".text = ''
    ${config.home.language.base}
  '';

  # Manage xdg mime.
  xdg.mime.enable = true;
  xdg.mimeApps.enable = true;
}
