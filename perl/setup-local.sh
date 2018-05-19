#!/bin/sh

# Set up a local perl directory.

install -d -m 750 ~/perl5

PERL_MB_OPT="--install_base \"${HOME}/perl5\""
PERL_MM_OPT="INSTALL_BASE=${HOME}/perl5"
PERL5LIB="${HOME}/perl5/lib/perl5"
PATH="${HOME}/perl5/bin:$PATH"
PERL_LOCAL_LIB_ROOT="${HOME}/perl5:$PERL_LOCAL_LIB_ROOT"

export PERL_MB_OPT
export PERL_MM_OPT
export PERL5LIB
export PATH
export PERL_LOCAL_LIB_ROOT

cpan local::lib
