#!/usr/bin/env bash

# Update our dotfiles.

cd "${HOME}/.dotfiles" && git pull && ./install
