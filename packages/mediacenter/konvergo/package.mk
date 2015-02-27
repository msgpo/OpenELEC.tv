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

PKG_NAME="konvergo"

case $PROJECT in
     Generic)
     PKG_VERSION="master"
     ;;
     RPi|RPi2)
     PKG_VERSION="Konvergo_RPi2"
     ;;
esac

PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://nightlies.plex.tv"
PKG_URL="$PKG_SITE/plex-oe-sources/$PKG_NAME-dummy.tar.gz"
PKG_DEPENDS_TARGET="toolchain systemd fontconfig qt libX11 xrandr libcec mpv SDL2 libXdmcp webclient"
PKG_DEPENDS_HOST="toolchain"
PKG_PRIORITY="optional"
PKG_SECTION="mediacenter"
PKG_SHORTDESC="Plex Konvergo Mediacenter"
PKG_LONGDESC="Plex Konvergo is the king or PC clients for Plex :P"

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

case $PROJECT in
  Generic)
  ;;

  RPi|RPi2)
    PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET omxplayer"
  ;;
esac

#add gdb tools if we are in debug
if [ "$DEBUG" = yes ]; then
	PKG_DEPENDS_TARGET="${PKG_DEPENDS_TARGET} gdb"
fi

unpack() {

        mkdir $BUILD/${PKG_NAME}-${PKG_VERSION}
        git clone -b $PKG_VERSION git@github.com:plexinc/konvergo.git  $BUILD/${PKG_NAME}-${PKG_VERSION}/.
	
	if [ "$DEBUG" = yes ]; then
		cd $BUILD/${PKG_NAME}-${PKG_VERSION}
		git submodule update --init

		#This is used when using QtCreator from the build tree to deploy to /storage root
		cp $PKG_DIR/QtCreatorDeployment.txt $ROOT/$BUILD/${PKG_NAME}-${PKG_VERSION}/

		#This allows cross compiler to find the libs that are used by other libs for QT5 
		cp $PKG_DIR/ld.so.conf $SYSROOT_PREFIX/etc/

		cd $ROOT
	fi	
}

configure_target() {
        cd ${ROOT}/${BUILD}/${PKG_NAME}-${PKG_VERSION}

        # Create seperate config build dir to not work in the github tree
        [ ! -d build ] && mkdir build
        cd build

        # Configure the build
	case $PROJECT in
        	Generic)
		cmake \
                        -DCMAKE_BUILD_TYPE=Debug \
                        -DCMAKE_LIBRARY_PATH="${SYSROOT_PREFIX}/usr/lib" \
                        -DCMAKE_PREFIX_PATH="${SYSROOT_PREFIX};${SYSROOT_PREFIX}/usr/local/qt5" \
                        -DCMAKE_INCLUDE_PATH="${SYSROOT_PREFIX}/usr/include" \
                        -DQTROOT=${SYSROOT_PREFIX}/usr/local/qt5 \
                        -DCMAKE_FIND_ROOT_PATH="${SYSROOT_PREFIX}/usr/local/qt5" \
                        -DUSE_QTQUICK=on \
                        -DENABLE_MPV=on \
                        -DCMAKE_VERBOSE_MAKEFILE=on \
                        $ROOT/$BUILD/$PKG_NAME-$PKG_VERSION/.
        	;;

        	RPi|RPi2)
		cmake \
			-DCMAKE_BUILD_TYPE=Debug \
			-DCMAKE_LIBRARY_PATH="${SYSROOT_PREFIX}/usr/lib" \
			-DCMAKE_PREFIX_PATH="${SYSROOT_PREFIX};${SYSROOT_PREFIX}/usr/local/qt5" \
			-DCMAKE_INCLUDE_PATH="${SYSROOT_PREFIX}/usr/include" \
			-DQTROOT=${SYSROOT_PREFIX}/usr/local/qt5 \
			-DCMAKE_FIND_ROOT_PATH="${SYSROOT_PREFIX}/usr/local/qt5" \
			-DUSE_QTQUICK=on \
			-DENABLE_MPV=on \
			-DENABLE_OMX=on \
			-DCMAKE_VERBOSE_MAKEFILE=on \
                        $ROOT/$BUILD/$PKG_NAME-$PKG_VERSION/.
        	;;
	esac
}

makeinstall_target() {

  	mkdir -p $INSTALL/usr/bin
        cp  $ROOT/$BUILD/$PKG_NAME-$PKG_VERSION/build/src/Konvergo ${INSTALL}/usr/bin/

	mkdir -p $INSTALL/usr/share/konvergo
	cp -R $ROOT/$BUILD/$PKG_NAME-$PKG_VERSION/resources/* ${INSTALL}/usr/share/konvergo
}