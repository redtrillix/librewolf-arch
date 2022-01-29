#!/bin/bash

PKGBUILD_NAME=${PKGBUILD_NAME:-'PKGBUILD'}
pacman --noconfirm -Syu --needed base-devel gnupg
# this is a very ugly fix for recent makepkg-5.1-chmod-shenanigans, which mess up the build process in docker
sed -E -i 's/^chmod a-s \"\$BUILDDIR\"$/# chmod a-s \"\$BUILDDIR\"/' `which makepkg`
echo 'nobody ALL=(ALL) NOPASSWD: /usr/bin/pacman' >> /etc/sudoers
mkdir -p /home/nobody && chown -R nobody /home/nobody
usermod -d /home/nobody nobody
# we need to un-expire the account, otherwise PAM will complain
usermod -e '' nobody
chown -R nobody .
# if [[ ! -z "${GLOBAL_MENUBAR}" ]];then
  # PKGBUILD_NAME='PKGBUILD_global_menubar'
# fi
sudo -u nobody -E -H gpg --import KEY
# makepkg will not run as root
sudo -u nobody -E -H makepkg --noconfirm --nosign --syncdeps --cleanbuild -p "${PKGBUILD_NAME}"
# if [[ ! -z "${GLOBAL_MENUBAR}" ]];then
  # mv  "librewolf-${pkgver}-${pkgrel}-${CARCH}.pkg.tar.zst" "librewolf-${pkgver}-${pkgrel}-${CARCH}.global_menubar.pkg.tar.zst"
# fi
