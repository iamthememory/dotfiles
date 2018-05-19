#!/bin/sh

# Set up the ccache variables.

if [ -d "/usr/lib/ccache/bin" ]
then
  PATH="$(munge.sh "$PATH" /usr/lib/ccache/bin)"
  export PATH
fi

CCACHE_DIR="${HOME}/.ccache"
export CCACHE_DIR

USE_CCACHE=1
export USE_CCACHE
