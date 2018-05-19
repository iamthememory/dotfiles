# Set up the nvm (node version manager).

# Set our nvm directory.
NVM_DIR="${HOME}/.nvm"
export NVM_DIR

# Lazily (on-demand) load nvm.
NVM_LAZY_LOAD=true
export NVM_LAZY_LOAD

# If there's a local .nvmrc, load/install the given node version.
NVM_AUTO_USE=true


# Add nvm.
antigen bundle lukechilds/zsh-nvm


# vim: ft=zsh
