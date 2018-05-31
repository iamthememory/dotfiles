# Set our zsh opts.

# Just type a directory to cd into it.
setopt autocd

# Enable spelling correction for commands.
setopt correct

# Use extended globs.
setopt extendedglob

# Use timestamps in history.
setopt extendedhistory

# Use ksh-style extended globbing, e.g. @(foo|bar).
setopt kshglob

# If a glob has no matches, remove it.
setopt nullglob

# pushd alone goes to the home directory, like plain cd.
setopt pushdtohome

# Disable cd adding to the directory stack.
unsetopt autopushd


# vim: ft=zsh
