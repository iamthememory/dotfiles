#!/bin/sh

# Add variables for our local perl packages.
# Note we can do similarly with
#   eval "$(perl -I$HOME/perl5/lib/perl5 -Mlocal::lib)"
# But that could add duplicates, so we just do pretty much the same thing here.

PATH="$(munge.sh "${PATH}" "${HOME}/perl5/bin")"
export PATH

PERL5LIB="$(munge.sh "${PERL5LIB}" "${HOME}/perl5/lib/perl5")"
export PERL5LIB

PERL_LOCAL_LIB_ROOT="$(munge.sh "${PERL_LOCAL_LIB_ROOT}" "${HOME}/perl5")"
export PERL_LOCAL_LIB_ROOT


PERL_MB_OPT="--install_base \"/home/iamthememory/perl5\""
export PERL_MB_OPT

PERL_MM_OPT="INSTALL_BASE=/home/iamthememory/perl5"
export PERL_MM_OPT
