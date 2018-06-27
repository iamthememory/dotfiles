#!/bin/sh

# Try to add general system bin directories, just in case they're missing, e.g.
# sbin directories on some distros.

for bindir in /bin /sbin /usr/bin /usr/sbin /usr/local/bin /usr/local/sbin
do
  PATH="$("${HOME}/.local/bin/munge.sh" "${PATH}" "${bindir}")"
done
unset bindir

export PATH
