#!/bin/sh

# $1: A colon separated list of directories, ala $PATH.
# $2: A directory to add to the variable if not already present.
# $3: head/tail: Add the variable to the beginning or end, default: head.

if [ "x$3" != "x" ] && [ "x$3" != "xhead" ] && [ "x$3" != "xtail" ]
then
  echo "Invalid arg 3 ($3): expecting head/tail" >&2
  exit 1
fi

if [ "x$1" = "x" ]
then
  # The list is empty.
  echo "$2"

elif echo "$1" | grep -Eq "(^|:)$2($|:)"
then
  # The path is already in the list.
  echo "$1"

else
  # Add the path to the list.

  if [ "x$3" = "xtail" ]
  then
    # Add at the tail.
    echo "$1:$2"

  else
    # Add at the head.
    echo "$2:$1"
  fi
fi
