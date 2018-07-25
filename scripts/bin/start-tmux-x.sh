#!/usr/bin/env bash

# Start tmux in a terminal, attaching if it already exists.

if tmux has-session >/dev/null 2>/dev/null
then
  exec st -e tmux attach
else
  exec st -e tmux new
fi
