#!/bin/sh

cd "${HOME}/.dotfiles/st/repo"

rm -f config.h

ln -s "../st-0.8.1.h" config.h
make PREFIX="${HOME}/.local" install

# st doesn't have a .gitignore, so clean up to avoid git telling us it's dirty.
make clean
rm config.h
