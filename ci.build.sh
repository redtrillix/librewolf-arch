#!/bin/bash

PKGBUILD_NAME=${PKGBUILD_NAME:-'PKGBUILD'}
pacman --noconfirm -Syu --needed base-devel gnupg

# NOTE: temporary workaround on aarch64 to manually add the wasi any packages
# while they are unavailable for aarch64/ALARM

if [[ ${CARCH} = "aarch64"  ]]; then
  wget https://archlinux.org/packages/community/any/wasi-compiler-rt/download -O wasi-compiler-rt-14.0.6-1-any.pkg.tar.zst
  wget https://archlinux.org/packages/community/any/wasi-libc/download -O wasi-libc-1_0+258+30094b6-1-any.pkg.tar.zst
  wget https://archlinux.org/packages/community/any/wasi-libc++/download -O wasi-libc++-14.0.6-1-any.pkg.tar.zst
  wget https://archlinux.org/packages/community/any/wasi-libc++abi/download -O wasi-libc++abi-14.0.6-1-any.pkg.tar.zst

  pacman -U wasi-compiler-rt-14.0.6-1-any.pkg.tar.zst wasi-libc-1_0+258+30094b6-1-any.pkg.tar.zst wasi-libc++-14.0.6-1-any.pkg.tar.zst wasi-libc++abi-14.0.6-1-any.pkg.tar.zst
fi

# this is a very ugly fix for recent makepkg-5.1-chmod-shenanigans, which mess up the build process in docker
sed -E -i 's/^chmod a-s \"\$BUILDDIR\"$/# chmod a-s \"\$BUILDDIR\"/' `which makepkg`
echo 'nobody ALL=(ALL) NOPASSWD: /usr/bin/pacman' >> /etc/sudoers
mkdir -p /home/nobody && chown -R nobody /home/nobody
usermod -d /home/nobody nobody
# we need to un-expire the account, otherwise PAM will complain
usermod -e '' nobody
chown -R nobody .

if [[ -n "${AARCH64_PGO}"  ]]; then
  sed -i 's/_build_profiled_aarch64=false/_build_profiled_aarch64=true/' "${PKGBUILD_NAME}"
fi

# if [[ ! -z "${GLOBAL_MENUBAR}" ]];then
  # PKGBUILD_NAME='PKGBUILD_global_menubar'
# fi

sudo -u nobody -E -H gpg --import KEY
# makepkg will not run as root
sudo -u nobody -E -H makepkg --noconfirm --nosign --syncdeps --cleanbuild -p "${PKGBUILD_NAME}"
# if [[ ! -z "${GLOBAL_MENUBAR}" ]];then
  # mv  "librewolf-${pkgver}-${pkgrel}-${CARCH}.pkg.tar.zst" "librewolf-${pkgver}-${pkgrel}-${CARCH}.global_menubar.pkg.tar.zst"
# fi
