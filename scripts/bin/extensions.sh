#!/bin/bash

extensions() {
  for f in "$@"
  do
    find "$f" -type f
  done \
    | sed 's/^.*\(\.[^.]*\)/\1/' \
    | sort \
    | uniq -c
}


extensions "$@"
