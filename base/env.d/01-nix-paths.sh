#!/bin/sh

# Add Nix locations to the paths.

for nixpath in "${HOME}/.nix-profile/bin" "/nix/var/nix/profiles/default/bin"
do
  PATH="$("${HOME}/.local/bin/munge.sh" "${PATH}" "${nixpath}")"
done
export PATH

MANPATH="$(manpath -q)"

for nixpath in "/nix/var/nix/profiles/default/share/man" "${HOME}/.nix-profile/share/man"
do
  MANPATH="$("${HOME}/.local/bin/munge.sh" "${MANPATH}" "${nixpath}")"
done
export MANPATH

INFOPATH="${INFOPATH:-':'}"

for nixpath in "/nix/var/nix/profiles/default/share/info" "${HOME}/.nix-profile/share/info"
do
  INFOPATH="$("${HOME}/.local/bin/munge.sh" "${INFOPATH}" "${nixpath}")"
done
export INFOPATH

unset nixpath
