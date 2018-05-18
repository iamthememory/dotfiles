#!/bin/bash

lrcfile="$1"
outfile="$2"
workdir="$(mktemp -dt "$(basename "$0").XXXXXXXX")"
macrobase="$(echo "$(basename "$outfile")" | sed 's/\.tf$//g')"
#trap " rm -rf \"$workdir\"" EXIT

dos2unix <"$lrcfile" |
  grep -E '^\[[0-9]{2}:[0-9]{2}\.[0-9]{2}\]' |
  grep -Ev -- '--- www\.LRCgenerator\.com ---' > "$workdir/lyrics.lrc"

sed -r 's/^\[([0-9]{2}:[0-9]{2}.[0-9]{2})\].*$/\1/' \
  <"$workdir/lyrics.lrc" >"$workdir/times"

sed -r 's/^\[[0-9]{2}:[0-9]{2}.[0-9]{2}\](.*)$/\1/' \
  <"$workdir/lyrics.lrc" >"$workdir/lyrics"

# From <http://stackoverflow.com/a/5875227/4535462>.
awk -F: '{\
  seconds = $1*60 + $2; \
  if (prev_seconds == 0) prev_seconds = seconds; \
  print seconds-prev_seconds; \
  prev_seconds=seconds;\
}' "$workdir/times" | tail -n +2 >"$workdir/reltimes"


echo "/def ${macrobase} = /${macrobase}_0" >"$workdir/out"

count=0

while IFS= read -r lyric
do
  if IFS= read -r delay <&3
  then
    echo "/def ${macrobase}_${count} = sing ${lyric}%;/repeat -${delay} 1 /${macrobase}_$((count+1))" >>"$workdir/out"
  else
    echo "/def ${macrobase}_${count} = sing ${lyric}" >>"$workdir/out"
  fi

  count="$((count+1))"
done <"$workdir/lyrics" 3<"$workdir/reltimes"

mv "$workdir/out" "$outfile"

rm -rf "$workdir"
