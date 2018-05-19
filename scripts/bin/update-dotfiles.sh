#!/bin/sh

# Update our dotfiles.

cd "${HOME}/.dotfiles" && git pull && ./install
