#!/bin/bash

# Toggle the mute status.

if [ "$(pamixer --get-mute)" = "false" ]
then
  pamixer --mute
else
  pamixer --unmute
fi

killall -USR1 i3status
