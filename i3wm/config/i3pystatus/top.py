#!/usr/bin/env python3
# -*- encoding: utf-8 -*-

from i3pystatus import Status
from i3pystatus.weather import weathercom
from subprocess import check_output
from i3pystatus.utils import gpu
from multiprocessing import cpu_count

status = Status(logfile='$HOME/.config/i3pystatus/log')



## GROUP

# Disk

#status.register('disk',
#                format='s: {avail:.0f} GiB',
#                critical_limit=100,
#                color='#00ff00',
#                path='/spool')
#
#status.register('disk',
#                format='r: {avail:.0f} GiB',
#                critical_limit=200,
#                color='#00ff00',
#                path='/rpool',
#                hints={'separator': False})
#
#status.register('disk',
#                format='b: {avail:.0f} GiB',
#                critical_limit=1000,
#                color='#00ff00',
#                mounted_only=True,
#                path='/bpool',
#                hints={'separator': False})

## GROUPEND




## GROUP

# Net

#status.register('ping',
#                format='{ping:5.1f} ms',
#                color='#00FF00',
#                latency_threshold=100,
#                host='8.8.8.8')

# Google.
status.register('ping',
                format='{ping:5.1f} ms',
                color='#00FF00',
                latency_threshold=150,
                interval=15,
                host='8.8.8.8')

# The FFXIV Chaos lobby.
status.register('ping',
                format='{ping:5.1f} ms',
                color='#00FF00',
                latency_threshold=150,
                interval=15,
                host='195.82.50.9',
                hints={'separator': False})

status.register('external_ip',
                format='→ {ip}',
                interval=60,
                hints={'separator': False})

status.register('net_speed',
                format='↓{speed_down:.1f}{down_units} ↑{speed_up:.1f}{up_units}',
                units='bytes',
                interval=30*60,
                hints={'separator': False})

status.register('network',
                #format_up='{interface}: {kbs}KB/s @ {essid} ({quality}%)',
                format_up='{interface}: ↓{bytes_recv:4.0f} KiB/s ↑{bytes_sent:4.0f} KiB/s[ @ {essid}][ ({quality:3d}%)] {v4cidr}',
                interface='wlo1',
                graph_width=8,
                recv_limit=8192,
                divisor=1024,
                next_if_down=False,
                hints={'separator': False})

## GROUPEND




## GROUP

# Load

status.register('load',
                format='Load: {avg1} {avg5} {avg15} {tasks}',
                critical_limit=6)

# Memory

status.register('swap',
                format='Swap: {used}/{total} GiB',
                divisor=1024**3)

status.register('mem',
                format='Mem: {used_mem}/{total_mem} GiB, F: {avail_mem} GiB',
                divisor=1024**3,
                hints={'separator': False})

# GPU

dogpu = False

try:
    gpu.query_nvidia_smi(0)
    dogpu = True
except:
    pass

if dogpu:
    status.register('gpu_temp',
                    format='{temp:.0f}°C',
                    alert_temp=80)

    status.register('gpu_mem',
                    format='{used_mem}/{total_mem} GiB',
                    divisor=1024,
                    hints={'separator': False})

    status.register('gpu_usage',
                    format='GPU: {usage:02d}%',
                    hints={'separator': False})

# CPU

status.register('temp',
                alert_temp=80)

status.register('cpu_usage',
                hints={'separator': False})

cpubarformat = ''.join(
    '{usage_bar_cpu' + str(n) + '}' for n in range(cpu_count())
)

status.register('cpu_usage_bar',
                format=('CPU: ' + cpubarformat),
                bar_type='vertical',
                hints={'separator': False})


## GROUPEND


status.run()
