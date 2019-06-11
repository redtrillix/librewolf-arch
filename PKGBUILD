# Maintainer: Jan Alexander Steffens (heftig) <jan.steffens@gmail.com>
# Contributor: Ionut Biru <ibiru@archlinux.org>
# Contributor: Jakub Schmidtke <sjakub@gmail.com>

pkgname=librewolf
_ffname=firefox
_pkgname=LibreWolf
pkgver=67.0.1
pkgrel=1
pkgdesc="Standalone web browser from mozilla.org"
arch=(x86_64)
license=(MPL GPL LGPL)
url="https://www.mozilla.org/firefox/"
depends=(gtk3 mozilla-common libxt startup-notification mime-types dbus-glib
         ffmpeg nss ttf-font libpulse)
makedepends=(unzip zip diffutils python2-setuptools yasm mesa imake inetutils
             xorg-server-xvfb autoconf2.13 rust mercurial clang llvm jack gtk2
             python nodejs python2-psutil cbindgen nasm git inkscape)
optdepends=('networkmanager: Location detection via available WiFi networks'
            'libnotify: Notification integration'
            'pulseaudio: Audio support'
            'speech-dispatcher: Text-to-Speech'
            'hunspell-en_US: Spell checking, American English')
options=(!emptydirs !makeflags)
_repo=https://hg.mozilla.org/mozilla-unified
source=( https://hg.cdn.mozilla.net/mozilla-unified/8646ea96944350a9e1b88881087011c582b94326.zstd-max.hg
        0001-bz-1521249.patch
        $pkgname.desktop
        mozilla.cfg.patch
        67_privileged_about.patch
        enable_addon_signing.patch
        git+https://github.com/${_pkgname}-Browser/${_pkgname}.git)
        # "hg+$_repo#tag=FIREFOX_${_pkgver//./_}_RELEASE"
        # ${_repo}/raw-file/default/python/mozboot/bin/bootstrap.py)
        #  firefox-symbolic.svg
sha256sums=('a3bbe198ec536018a7bfc07c648325fce43397cf747b02f5107d0c198d43fdcf'
            'd0673786a6a1f1b9f6f66a3a1356afa33f1f18f59dabd92bd193c88c52a1d04c'
            'ad6b1bc47687c8f094a0b8dd077b13099d43fc95469b73ec9890e642512d474e'
            '8d121274fc59243c77424dc633796aaa01f1a55ec98bf0decd34b676ab07ba6f'
            '55ce087c4b7d9c745ede9d4ad452f57229ec179d84c74817611463b6976f2d6f'
            '64d8141aa43c7ec7cafef26656685d83fc663bcf38cd40428356e2d7ddfb16bc'
            'SKIP')

prepare() {
  mkdir mozbuild
  mkdir mozilla-unified

  # hg clone failed / timed out on my machines so we use the bundle

  hg init mozilla-unified
  cd mozilla-unified
  hg unbundle ${srcdir}/8646ea96944350a9e1b88881087011c582b94326.zstd-max.hg
  cat > .hg/hgrc <<END
[paths]
default = https://hg.mozilla.org/mozilla-unified/
END
  hg pull
  hg update "FIREFOX_${pkgver//./_}_RELEASE"

  # https://bugzilla.mozilla.org/show_bug.cgi?id=1521249
  patch -Np1 -i ../0001-bz-1521249.patch

  cd ${srcdir}/${_pkgname}
  # unlock some prefs I deem worthy of keeping unlocked
  # (once installed systemwide, you'd otherwise always have to
  # sudo around in /usr/lib)
  patch -Np1 -i ${srcdir}/mozilla.cfg.patch
  # privilegedabout_process is introduced after 67,
  # can be removed when switching to 68
  patch -Np1 -i ${srcdir}/67_privileged_about.patch
  # keeps addon signing enabled
  patch -Np1 -i ${srcdir}/enable_addon_signing.patch
  cd ${srcdir}/mozilla-unified


  local ICON_FILE_PATH=$srcdir/$_pkgname/branding/icon/icon.svg;
  local BRANDING_FOLDER_PATH=$srcdir/$_pkgname/${pkgname}_browser/source_files/browser/branding/librewolf;

  # generate icons and moves them to the branding folder
  echo Generating icons from $ICON_FILE_PATH and moving to $BRANDING_FOLDER_PATH;
  inkscape --without-gui --file=$ICON_FILE_PATH --export-png=$BRANDING_FOLDER_PATH/default16.png --export-width=16 --export-height=16;
  inkscape --without-gui --file=$ICON_FILE_PATH --export-png=$BRANDING_FOLDER_PATH/default32.png --export-width=32 --export-height=32;
  inkscape --without-gui --file=$ICON_FILE_PATH --export-png=$BRANDING_FOLDER_PATH/default48.png --export-width=48 --export-height=48;
  inkscape --without-gui --file=$ICON_FILE_PATH --export-png=$BRANDING_FOLDER_PATH/default64.png --export-width=64 --export-height=64;
  inkscape --without-gui --file=$ICON_FILE_PATH --export-png=$BRANDING_FOLDER_PATH/default128.png --export-width=128 --export-height=128;
  inkscape --without-gui --file=$ICON_FILE_PATH --export-png=$BRANDING_FOLDER_PATH/VisualElements_70.png --export-width=70 --export-height=70;
  inkscape --without-gui --file=$ICON_FILE_PATH --export-png=$BRANDING_FOLDER_PATH/VisualElements_150.png --export-width=150 --export-height=150;


  cat >.mozconfig <<END
ac_add_options --enable-application=browser

ac_add_options --prefix=/usr
ac_add_options --enable-release
ac_add_options --enable-hardening
ac_add_options --enable-optimize
ac_add_options --enable-rust-simd
ac_add_options --enable-lto
export MOZ_PGO=1
export CC=clang
export CXX=clang++
export AR=llvm-ar
export NM=llvm-nm
export RANLIB=llvm-ranlib

# Branding
# ac_add_options --enable-official-branding
ac_add_options --enable-update-channel=release
ac_add_options --with-app-name=${pkgname}
ac_add_options --with-app-basename=${_pkgname}
ac_add_options --with-branding=browser/branding/${pkgname}
ac_add_options --with-distribution-id=io.github.${pkgname}
# export MOZILLA_OFFICIAL=0
export MOZ_APP_REMOTINGNAME=${_pkgname//-/}
# export MOZ_TELEMETRY_REPORTING=0
export MOZ_REQUIRE_SIGNING=1

# Keys
# ac_add_options --with-google-location-service-api-keyfile=${PWD@Q}/google-api-key
# ac_add_options --with-google-safebrowsing-api-keyfile=${PWD@Q}/google-api-key
# ac_add_options --with-mozilla-api-keyfile=${PWD@Q}/mozilla-api-key

# System libraries
ac_add_options --with-system-nspr
ac_add_options --with-system-nss

# Features
ac_add_options --enable-alsa
ac_add_options --enable-jack
ac_add_options --enable-startup-notification
ac_add_options --disable-crashreporter
ac_add_options --disable-gconf
ac_add_options --disable-updater
END

  cp -r ${srcdir}/${_pkgname}/${pkgname}_browser/source_files/{docshell,browser} ./

  # workaround for branding-common.mozbuild looking for firefox-branding.js
  cp browser/branding/librewolf/pref/librewolf-preferences.js browser/branding/librewolf/pref/firefox-branding.js
}


build() {
  cd mozilla-unified

  export MOZ_SOURCE_REPO="$_repo"
  export MOZ_NOSPAM=1
  export MOZBUILD_STATE_PATH="$srcdir/mozbuild"

  # LTO needs more open files
  ulimit -n 4096

  xvfb-run -a -n 97 -s "-screen 0 1600x1200x24" ./mach build
  ./mach buildsymbols
}

package() {
  cd mozilla-unified
  DESTDIR="$pkgdir" ./mach install
  find . -name '*crashreporter-symbols-full.zip' -exec cp -fvt "$startdir" {} +

  _vendorjs="$pkgdir/usr/lib/$pkgname/browser/defaults/preferences/vendor.js"
  install -Dm644 /dev/stdin "$_vendorjs" <<END
// Use LANG environment variable to choose locale
pref("intl.locale.requested", "");

// Use system-provided dictionaries
pref("spellchecker.dictionary_path", "/usr/share/hunspell");

// Disable default browser checking.
pref("browser.shell.checkDefaultBrowser", false);

// Don't disable our bundled extensions in the application directory
pref("extensions.autoDisableScopes", 11);
pref("extensions.shownSelectionUI", true);
END

  cp -r ${srcdir}/${_pkgname}/settings/* $pkgdir/usr/lib/$pkgname

  _distini="$pkgdir/usr/lib/$pkgname/distribution/distribution.ini"
  install -Dm644 /dev/stdin "$_distini" <<END
[Global]
id=io.github.${pkgname}
version=1.0
about=LibreWolf Arch Linux

[Preferences]
app.distributor=archlinux
app.distributor.channel=$pkgname
app.partner.archlinux=archlinux
END

  for i in 16 32 48 64 128; do
    install -Dm644 browser/branding/${pkgname}/default$i.png \
      "$pkgdir/usr/share/icons/hicolor/${i}x${i}/apps/$pkgname.png"
  done
  install -Dm644 browser/branding/librewolf/content/about-logo.png \
    "$pkgdir/usr/share/icons/hicolor/192x192/apps/$pkgname.png"
  # install -Dm644 browser/branding/official/content/about-logo@2x.png \
    # "$pkgdir/usr/share/icons/hicolor/384x384/apps/$pkgname.png"

  # arch upstream provides a separate svg for this. we don't have that, so let's re-use 16.png
  install -Dm644 browser/branding/${pkgname}/icons/default16.png \
    "$pkgdir/usr/share/icons/hicolor/symbolic/apps/$pkgname-symbolic.png"

  install -Dm644 ../$pkgname.desktop \
    "$pkgdir/usr/share/applications/$pkgname.desktop"

  # Install a wrapper to avoid confusion about binary path
  install -Dm755 /dev/stdin "$pkgdir/usr/bin/$pkgname" <<END
#!/bin/sh
exec /usr/lib/$pkgname/firefox "\$@"
END

  # Replace duplicate binary with wrapper
  # https://bugzilla.mozilla.org/show_bug.cgi?id=658850
  ln -srf "$pkgdir/usr/bin/$pkgname" \
    "$pkgdir/usr/lib/$pkgname/firefox-bin"
}

# vim:set sw=2 et:
