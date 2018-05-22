#!/bin/sh

set -e

uname="iamthememory"

# Set up an Ubuntu system.

ensuregroups() {
  for g in "$@"
  do
    getent group "$g" || groupadd "$g"
  done
}


ensureingroup() {
  user="$1"
  shift

  for g in "$@"
  do
    getent group "$g" && gpasswd -a "$user" "$g"
  done
}


cat > /etc/apt/sources.list << EOF
deb http://archive.ubuntu.com/ubuntu bionic main restricted universe multiverse
EOF

cat > /etc/locale.gen << EOF
# This file lists locales that you wish to have built. You can find a list
# of valid supported locales at /usr/share/i18n/SUPPORTED, and you can add
# user defined locales to /usr/local/share/i18n/SUPPORTED. If you change
# this file, you need to rerun locale-gen.


EOF
cat /usr/share/i18n/SUPPORTED >> /etc/locale.gen
locale-gen

update-locale LANG=en_US.UTF-8


# Update packages.

apt update
apt-get dist-upgrade


# Docker repository.
apt install apt-transport-https ca-certificates curl software-properties-common

echo 'deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic edge' \
  > /etc/apt/sources.list.d/docker.list

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

apt update


# Install packages.

# Others:
#  - pamixer
#  - playerctl
#  - spotify
#  - slack
#  - unclutter-xfixes

apt install \
  acct \
  ack \
  acl \
  amd64-microcode \
  apparmor \
  apparmor-notify \
  apparmor-profiles \
  apparmor-profiles-extra \
  aria2 \
  avahi-daemon \
  avahi-discover \
  avahi-ui-utils \
  avahi-utils \
  baobab \
  bash-completion \
  bind9utils \
  btrfs-progs \
  build-essential \
  cabal-install \
  ccache \
  chromium-browser \
  chrony \
  clang \
  cloc \
  cmake \
  cmake-curses-gui \
  cmake-extras \
  cmake-qt-gui \
  cookiecutter \
  debootstrap \
  debugedit \
  docker-ce \
  dos2unix \
  dstat \
  ecryptfs-utils \
  entr \
  eog \
  etckeeper \
  exuberant-ctags \
  firefox \
  fonts-liberation \
  fonts-liberation2 \
  ftp \
  fwupd \
  g++ \
  g++-4.8-multilib \
  g++-5-multilib \
  g++-6-multilib \
  g++-7-multilib \
  g++-8-multilib \
  gcc \
  gcc-4.8-multilib \
  gcc-5-multilib \
  gcc-6-multilib \
  gcc-7-multilib \
  gcc-8-multilib \
  gdb \
  gdb-multiarch \
  gddrescue \
  gdisk \
  geoip-bin \
  geoipupdate \
  gimp \
  git \
  git-all \
  git-lfs \
  glances \
  gnome-disk-utility \
  gnuplot \
  graphviz \
  grub-efi \
  grub-efi-amd64 \
  grub-rescue-pc \
  grub-splashimages \
  gufw \
  hplip \
  hplip-gui \
  htop \
  i3 \
  i3lock \
  ibus \
  ibus-table \
  ibus-table-latex \
  inkscape \
  intel-microcode \
  iotop \
  iw \
  language-pack-en \
  libdbus-1-dev \
  libgeoip-dev \
  libglib2.0-dev \
  libiw-dev \
  libnss-mdns \
  lightdm \
  lightdm-gtk-greeter \
  lightdm-gtk-greeter-settings \
  lightdm-settings \
  links \
  linux-firmware \
  linux-generic \
  linux-headers-generic \
  linux-image-generic \
  lm-sensors \
  lsof \
  megatools \
  memtest86+ \
  mlocate \
  mosh \
  mpc \
  mpd \
  mpv \
  mtr \
  multipath-tools \
  nautilus \
  ncmpcpp \
  nethack-console \
  network-manager \
  network-manager-gnome \
  ngrep \
  nmap \
  numlockx \
  octave \
  os-prober \
  pandoc \
  parallel \
  pavucontrol \
  perl \
  picard \
  pinfo \
  pkg-config \
  pngcrush \
  pv \
  pwgen \
  pydf \
  python-pip \
  python-virtualenv \
  python3-pip \
  python3-virtualenv \
  redshift \
  ruby \
  ruby-bundler \
  ruby-dev \
  scanmem \
  scrot \
  seahorse \
  seahorse-nautilus \
  silversearcher-ag \
  snapcraft \
  snapd \
  socat \
  sox \
  squashfs-tools \
  sshfs \
  strace \
  suckless-tools \
  sudo \
  systemtap \
  telnet \
  thunderbird \
  time \
  tmate \
  tmux \
  tor \
  torsocks \
  traceroute \
  tree \
  ttyrec \
  ubuntu-desktop \
  ubuntu-gnome-desktop \
  ubuntu-restricted-extras \
  ubuntu-restricted-extras \
  ubuntu-standard \
  ufw \
  unrar \
  valgrind \
  vim \
  vim-doc \
  vim-scripts \
  wget \
  wireless-tools \
  wireshark \
  xclip \
  xdg-user-dirs \
  xdg-user-dirs-gtk \
  xdotool \
  xfsprogs \
  xorg \
  xpra \
  xss-lock \
  youtube-dl \
  zenity \
  zenmap \
  zfs-initramfs \
  zfsutils-linux \
  zsh


# Add user.
getent passwd "$uname" || adduser \
  "$uname" \
  --home /home/$uname \
  --shell /bin/zsh


# Add groups.
ensuregroups \
  downloads \
  ebook \
  music \
  src \
  steam 


# Add user to groups.
ensuregroups "$uname" \
  audio \
  cdrom \
  cdrw \
  cron \
  crontab \
  dialout \
  docker \
  downloads \
  ebook \
  games \
  gamestat \
  input \
  kvm \
  lpadmin \
  music \
  plugdev \
  src \
  steam \
  sudo \
  systemd-journal \
  usb \
  users \
  uucp \
  video \
  wheel \
  wireshark


# Create directories.
install -d -o root -g root -m 755 /var/cache/ccache
install -d -o "$uname" -g "$uname" -m 700 /var/cache/ccache/"$uname"

install -d -o root -g root -m 755 /data

install -d -o root -g downloads -m u=rwx,g=rwxs,o= /data/downloads
setfacl -m 'd:u::rwx' /data/downloads
setfacl -m 'd:g::rwx' /data/downloads
setfacl -m 'd:o::---' /data/downloads
ln -fsv /data/downloads /home/"$uname"/Downloads

install -d -o root -g ebook -m u=rwx,g=rwxs,o= /data/ebook
setfacl -m 'd:u::rwx' /data/ebook
setfacl -m 'd:g::rwx' /data/ebook
setfacl -m 'd:o::---' /data/ebook

install -d -o root -g music -m u=rwx,g=rwxs,o= /data/music
setfacl -m 'd:u::rwx' /data/music
setfacl -m 'd:g::rwx' /data/music
setfacl -m 'd:o::---' /data/music
ln -fsv /data/music /home/"$uname"/Music

install -d -o root -g src -m u=rwx,g=rwxs,o= /data/src
setfacl -m 'd:u::rwx' /data/src
setfacl -m 'd:g::rwx' /data/src
setfacl -m 'd:o::---' /data/src
ln -fsv /data/src /home/"$uname"/src
