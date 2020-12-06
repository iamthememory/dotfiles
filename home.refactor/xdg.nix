# Set the values for the XDG directories.
{
  config,
  ...
}: let
  inherit (config.home) homeDirectory;
  inherit (config.xdg) userDirs;
in {
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

  xdg.userDirs.desktop = "${homeDirectory}";
  xdg.userDirs.documents = "${homeDirectory}/src";
  xdg.userDirs.download = "${homeDirectory}/Downloads";
  xdg.userDirs.music = "${homeDirectory}/Music";
  xdg.userDirs.pictures = "${homeDirectory}";
  xdg.userDirs.publicShare = "${homeDirectory}";
  xdg.userDirs.templates = "${homeDirectory}";
  xdg.userDirs.videos = "${homeDirectory}";

  xdg.userDirs.extraConfig.XDG_MAIL_DIR = "${homeDirectory}/Mail";

  home.sessionVariables.XDG_DESKTOP_DIR = userDirs.desktop;
  home.sessionVariables.XDG_DOCUMENTS_DIR = userDirs.documents;
  home.sessionVariables.XDG_DOWNLOAD_DIR = userDirs.download;
  home.sessionVariables.XDG_MUSIC_DIR = userDirs.music;
  home.sessionVariables.XDG_PICTURES_DIR = userDirs.pictures;
  home.sessionVariables.XDG_PUBLICSHARE_DIR = userDirs.publicShare;
  home.sessionVariables.XDG_TEMPLATES_DIR = userDirs.templates;
  home.sessionVariables.XDG_VIDEOS_DIR = userDirs.videos;

  home.sessionVariables.XDG_MAIL_DIR = userDirs.extraConfig.XDG_MAIL_DIR;

  # Add the xdg locale file, installed/used by xdg-user-dirs.
  xdg.configFile."user-dirs.locale".text = ''
    ${config.home.language.base}
  '';

  # Manage xdg mime.
  xdg.mime.enable = true;
  xdg.mimeApps.enable = true;
}
