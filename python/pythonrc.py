# This file is sourced by interactive python sessions
# Partially copied from <http://stackoverflow.com/questions/3613418/what-is-in-your-python-interactive-startup-script>

from __future__ import division, print_function

import atexit
import os
import readline
import rlcompleter

# Tab complete with readline
readline.parse_and_bind("tab: complete")

# History
historyPath = os.path.expanduser("~/.history.py")

def save_history(historyPath=historyPath):
    import readline
    readline.write_history_file(historyPath)

if os.path.exists(historyPath):
    readline.read_history_file(historyPath)

atexit.register(save_history)
del os, atexit, readline, rlcompleter, save_history, historyPath

# vim: tabstop=8 expandtab shiftwidth=4 softtabstop=4
