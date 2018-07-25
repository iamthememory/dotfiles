#!/bin/sh

# Add to our ls colors.

eval `dircolors ~/dotfiles/base/dircolors-solarized/dircolors.ansi-dark`

for color in \
  '*.green=04;32'
do
  LS_COLORS="$(munge.sh "${LS_COLORS}" "${color}" tail)"
done

export LS_COLORS
unset color
