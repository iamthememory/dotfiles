#!/usr/bin/env bash

export LINES=24
export COLUMNS=80

logbase="${HOME}/.nethacklogs"

saves="$(find "${HOME}/.config/nethack/save" -name "$(id -u)"'*' | wc -l)"

if [ "${saves}x" = "0x" ]
then
  logfile="${logbase}/$(date '+%Y/%Y-%m/%Y-%m-%d/%Y-%m-%dT%H:%M:%S').ttyrec"
  mkdir -p "$(dirname "${logfile}")"
  exec ttyrec -e nethack "${logfile}"
else
  logfile="$(find "${logbase}" -type f -name '*.ttyrec' -print0 | sort -zr | head -n 1 -z | tr -d '\0')"
  exec ttyrec -e nethack -a "${logfile}"
fi
