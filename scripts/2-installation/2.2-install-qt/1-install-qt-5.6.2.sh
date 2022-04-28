#! /bin/bash
set -e

QT_MAIN_VERSION=5.6
QT_VERSION=5.6.2

INSTALL_PATH=/opt/Qt-$QT_VERSION
export PATH=$INSTALL_PATH/bin:$PATH

# prerequisites for "build from Git"
sudo yum -y install libxcb libxcb-devel xcb-util xcb-util-devel mesa-libGL-devel libxkbcommon-devel fontconfig


# download and install prebuild packages
# you must startX first
if [ `uname -m` == 'x86_64' ]; then
    QT_BINARY_PACKAGE=qt-opensource-linux-x64-$QT_VERSION.run
    wget -nc https://download.qt.io/new_archive/qt/$QT_MAIN_VERSION/$QT_VERSION/$QT_BINARY_PACKAGE
    chmod +x $QT_BINARY_PACKAGE
    ./$QT_BINARY_PACKAGE
fi

# or build from Git
# https://wiki.qt.io/Building_Qt_5_from_Git


echo 'Success!'
