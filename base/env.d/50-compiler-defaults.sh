#!/bin/sh

# Some default compiler flags.
CFLAGS="-march=native -O2 -pipe -ggdb -fstack-protector-strong"
CXXFLAGS="${CFLAGS}"
FFLAGS="${CFLAGS}"
FCFLAGS="${CFLAGS}"

export CFLAGS
export CXXFLAGS
export FFLAGS
export FCFLAGS
