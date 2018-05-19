#!/bin/sh

# Load our XDG directory variables.
. "${HOME}/.config/user-dirs.dirs"

# Export them.
export XDG_DESKTOP_DIR
export XDG_DOCUMENTS_DIR
export XDG_DOWNLOAD_DIR
export XDG_MUSIC_DIR
export XDG_PICTURES_DIR
export XDG_PUBLICSHARE_DIR
export XDG_TEMPLATES_DIR
export XDG_VIDEOS_DIR

# Our default config directory.
XDG_CONFIG_HOME="${HOME}/.config"
export XDG_CONFIG_HOME

# Our default cache directory.
XDG_CACHE_HOME="${HOME}/.cache"
export XDG_CACHE_HOME

# Our default data directory.
XDG_DATA_HOME="${HOME}/.local/share"
export XDG_DATA_HOME
