{ pkgs, ... }:
pkgs.writeScript "i3pystatus-bottom.py" ''
  #!${pkgs.python3}/bin/python3
  # -*- encoding: utf-8 -*-

  from i3pystatus import Status
  from i3pystatus.weather import weathercom
  from subprocess import check_output
  from os.path import expanduser, exists
  import subprocess
  import re

  status = Status(logfile='$HOME/.config/i3pystatus/log')

  ## GROUP

  # Times.

  status.register('uname',
                  format='{nodename}')

  status.register('weather',
                  format='{icon} {current_temp}{temp_unit}/{feelslike}{temp_unit}',
                  colorize=True,
                  backend=weathercom.Weathercom(
                        location_code='44065',
                        units='imperial'),
                  interval=20*60)

  status.register('moon',
                  format='{moonicon} {status} {illum:.02f}%',
                  interval=10)

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

  # Get our zpools.
  zdata = subprocess.check_output(
      args=[
          '${pkgs.zfs}/bin/zfs',
          'list',
          '-H',
          '-p',
          '-d', '0',
          '-o', 'name,mountpoint',
      ]
  ).decode().splitlines()

  pools = list(reversed(sorted({
      re.sub(r'^(.+)pool$', '\g<1>', d[0]): d[1]
      for s in zdata
      for d in [s.split('\t')]
  }.items())))

  if len(pools) > 0:
      p = pools.pop(0)
      status.register('disk',
                      format=p[0] + ': {avail:.0f} GiB',
                      critical_limit=40,
                      color='#00ff00',
                      mounted_only=True,
                      path=(p[1] if p[1] != 'legacy' else '/' + p[0] + 'pool')
      )

  for p in pools:
      status.register('disk',
                      format=p[0] + ': {avail:.0f} GiB',
                      critical_limit=40,
                      color='#00ff00',
                      mounted_only=True,
                      path=(p[1] if p[1] != 'legacy' else '/' + p[0] + 'pool'),
                      hints={'separator': False}
      )

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
                  critical_level_percentage=25,
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
  #                    host=expanduser('~/.config/mpd/socket'),
  #                    port=0,
  #                    hints={'separator': False})

  status.register(
      'spotify',
      player='spotify',
      format='{status} {title}[ by {artist}]',
      on_leftclick=['player_command', 'Previous'],
      on_middleclick='playpause',
      on_rightclick='next_song',
      hints={'separator': False},
  )

  ## GROUPEND

  status.run()
''
