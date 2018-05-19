# Load completion scripts.
autoload -U compinit promptinit bashcompinit
compinit
promptinit
bashcompinit

# Interactively choose from multiple completions.
zstyle ':completion::complete:*' use-cache 1

# vim: ft=zsh
