#!/bin/sh

# Add ~/.local/bin to the PATH.

PATH="$("${HOME}/.local/bin/munge.sh" "${PATH}" "${HOME}/.local/bin")"
export PATH
