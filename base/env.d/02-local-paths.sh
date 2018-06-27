#!/bin/sh

# Add ~/.local/... to the PATH.

PATH="$("${HOME}/.local/bin/munge.sh" "${PATH}" "${HOME}/.local/bin")"
export PATH

MANPATH="$(munge.sh "$(manpath -q)" "${HOME}/.local/share/man")"
export MANPATH
