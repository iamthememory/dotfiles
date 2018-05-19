# Apply our antigen configuration.
# This *must* be done after all our antigen bundles are set up.

antigen apply

# oh-my-zsh and such overwrite some of our settings.
# Re-set them.
if [ -f ~/.zshenv ] && [ -r ~/.zshenv ]
then
  . ~/.zshenv
fi


# vim: ft=zsh
