#!/usr/bin/env bash

set -e

isbnadd() {
  local isbnfile="$1"
  shift

  for file in "$@"
  do
    local realname="$(readlink -f "${file}")"

    if [[ "${realname}" =~ \.epub$ ]]
    then
      nohup FBReader "${realname}" >/dev/null 2>/dev/null &
    else
      nohup evince "${realname}" >/dev/null 2>/dev/null &
    fi

    local readerpid="$!"
    disown

    echo -ne "${file} ISBN: "
    read isbn

    local sanisbn="$(echo "$isbn" | sed 's/[^0-9X]//g')"

    if [ "x${sanisbn}" != "x" ]
    then
      echo "${sanisbn} >> ${realname}" \
        | tee -a "${isbnfile}"
    fi

    kill "${readerpid}"
  done
}


doisbns() {
  local isbnfile="$(mktemp /tmp/calibre-isbnadd.XXXXXXXX)"

  trap 'rm -f '"${isbnfile}" EXIT INT TERM

  isbnadd "${isbnfile}" "$@"

  xclip -sel clipboard < "${isbnfile}"

  rm -f "${isbnfile}"
}


doisbns "$@"
