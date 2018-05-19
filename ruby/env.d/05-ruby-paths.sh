#!/bin/sh

# Load local ruby gem paths.

GEM_HOME="$(ruby -e 'print Gem.user_dir')"
export GEM_HOME

GEM_PATH="$(munge.sh "${GEM_PATH}" "${GEM_HOME}")"
export GEM_PATH

PATH="$(munge.sh "${PATH}" "$(ruby -e 'print Gem.bindir')")"
export PATH
