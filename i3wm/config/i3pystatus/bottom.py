#!/usr/bin/env python3
# -*- encoding: utf-8 -*-

from i3pystatus import Status
from i3pystatus.weather import weathercom
from subprocess import check_output
from os.path import expanduser, exists

status = Status(logfile='$HOME/.config/i3pystatus/log')

## GROUP

# Times.

status.register('clock',
                format='%a %Y-%m-%d %H:%M:%S')

status.register('uptime',
                format='up [{days} ]{hours}:{mins:02d}',
                color='#ffff00',
                alert=True,
                color_alert='#00ff00',
                seconds_alert=60*60*24)

## GROUPEND



## GROUP

# Disk

status.register('disk',
                format='s: {avail:.0f} GiB',
                critical_limit=100,
                color='#00ff00',
                path='/spool')

status.register('disk',
                format='r: {avail:.0f} GiB',
                critical_limit=200,
                color='#00ff00',
                path='/rpool',
                hints={'separator': False})

status.register('disk',
                format='e: {avail:.0f} GiB',
                critical_limit=100,
                color='#00ff00',
                mounted_only=True,
                path='/epool',
                hints={'separator': False})

status.register('disk',
                format='b: {avail:.0f} GiB',
                critical_limit=1000,
                color='#00ff00',
                mounted_only=True,
                path='/bpool',
                hints={'separator': False})

## GROUPEND


## GROUP

# Backlight

status.register('backlight',
                format='☀ {percentage}%')

# Battery

status.register('battery',
                format='{status}: {percentage_design:4.02f}%[ ({remaining})]',
                alert=True,
                alert_percentage=50,
                critical_level_percentage=30,
                critical_level_command='systemctl suspend',
                color='#ffff00',
                hints={'separator': False})

## GROUPEND



## GROUP

# Media

status.register('pulseaudio',
                format='{volume}%')

#if exists(expanduser('~/.config/mpd')):
#    status.register('mpd',
#                    format='{status} {title}[ from {album}][ by {artist}] {song_elapsed}/{song_length}',
#                    host='/home/iamthememory/.config/mpd/socket',
#                    port=0,
#                    hints={'separator': False})

status.register(
    'spotify',
    format='{status} {title}[ by {artist}]',
    on_leftclick=['player_command', 'Previous'],
    on_middleclick='playpause',
    on_rightclick='next_song',
    hints={'separator': False},
)

## GROUPEND

status.run()
