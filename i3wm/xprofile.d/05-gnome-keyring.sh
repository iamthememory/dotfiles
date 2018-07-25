# Start up gnome-keyring.

eval $(gnome-keyring-daemon --components=pkcs11,secrets,ssh,gpg)
export SSH_AUTH_SOCK
