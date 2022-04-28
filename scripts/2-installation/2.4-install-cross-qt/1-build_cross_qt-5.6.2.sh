#! /bin/bash
set -e

QT_MAIN_VERSION=5.6
QT_VERSION=5.6.2
QT_SOURCE_PACKAGE=qtbase-opensource-src-$QT_VERSION

ARCH=aarch64
PLATFORM=linux-$ARCH-gnu-g++

INSTALL_PATH=/opt/Qt-$QT_VERSION-$ARCH-static
export PATH=$INSTALL_PATH/bin:$PATH

#CONFIGURATION_OPTIONS=" -opensource -confirm-license -no-opengl -v "
CONFIGURATION_OPTIONS=" -opensource -confirm-license -static -make libs -optimized-qmake -pch -qt-sql-sqlite -qt-libjpeg -qt-zlib -qt-libpng -v "
PARALLEL_MAKE=-j$(nproc)

CC_INSTALL_PATH=/opt/gcc-10.2.0-$ARCH
CC_TARGET=$ARCH-linux-gnu
export PATH=$CC_INSTALL_PATH/bin:$PATH
export LD_LIBRARY_PATH=$CC_INSTALL_PATH/$CC_TARGET/lib64/


# Download packages
wget -nc https://download.qt.io/new_archive/qt/$QT_MAIN_VERSION/$QT_VERSION/submodules/$QT_SOURCE_PACKAGE.tar.xz

# Extract everything
tar xfk $QT_SOURCE_PACKAGE.tar.xz
cd $QT_SOURCE_PACKAGE

# Create platform qmake
tar xzvf ../$PLATFORM.tar.gz -C ./mkspecs

# Make & Install
./configure -release -prefix $INSTALL_PATH -xplatform $PLATFORM $CONFIGURATION_OPTIONS
make $PARALLEL_MAKE
make install
cd ..

# Check installation
$INSTALL_PATH/bin/qmake -v
file $INSTALL_PATH/lib/libQt5Core.so.$QT_VERSION

echo 'Success!'
