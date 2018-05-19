#!/bin/sh

# Set the go environment variables.

GOPATH="${HOME}/.local/go"
export GOPATH

PATH="$(munge.sh "$PATH" "${GOPATH}/bin")"
export PATH
