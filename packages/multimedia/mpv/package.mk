################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2014 Stephan Raue (stephan@openelec.tv)
#
#  OpenELEC is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 2 of the License, or
#  (at your option) any later version.
#
#  OpenELEC is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with OpenELEC.  If not, see <http://www.gnu.org/licenses/>.
################################################################################

PKG_NAME="mpv"
PKG_VERSION="0.7.4"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://plexrpms.markwalker.dk/"
PKG_URL="$PKG_SITE/private/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain libmad qt"
PKG_PRIORITY="optional"
PKG_SECTION="multimedia"
PKG_SHORTDESC="MPV Movie Player
PKG_LONGDESC="

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_TARGET="--enable-libmpv-shared --disable-cplayer --disable-apple-remote --prefix=${ROOT}/${BUILD}/image/system/usr"

configure_target() {

	pushd ${ROOT}/${BUILD}/${PKG_NAME}-${PKG_VERSION}
	./bootstrap.py
        ./waf configure ${PKG_CONFIGURE_OPTS_TARGET}
        popd
}

make_target() {
	pushd ${ROOT}/${BUILD}/${PKG_NAME}-${PKG_VERSION}
        ./waf build
        popd
}

pre_install() {
        makeinstall_target
}

makeinstall_target() {

	pushd ${ROOT}/${BUILD}/${PKG_NAME}-${PKG_VERSION}
        ./waf install
        popd
}
