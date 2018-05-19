#!/bin/sh

# Add ~/.local/... to the PATH.

PATH="$("${HOME}/.local/bin/munge.sh" "${PATH}" "${HOME}/.local/bin")"
export PATH

MANPATH="$(munge.sh "${MANPATH}" "${HOME}/.local/share/man")"
export MANPATH
