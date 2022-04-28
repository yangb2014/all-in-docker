#! /bin/bash
set -e

CMAKE_MAIN_VERSION=3.17
CMAKE_VERSION=3.17.5
CMAKE_SOURCE_PACKAGE=cmake-$CMAKE_VERSION
INSTALL_PATH=/usr/local/$CMAKE_SOURCE_PACKAGE
export PATH=$INSTALL_PATH/bin:$PATH

CONFIGURATION_OPTIONS=""
PARALLEL_MAKE=-j4

# Download packages
wget -nc https://cmake.org/files/v$CMAKE_MAIN_VERSION/$CMAKE_SOURCE_PACKAGE.tar.gz

# Extract everything
for f in *.tar*; do tar xfk $f; done

# Build & install
mkdir -p build-cmake
cd build-cmake
../$CMAKE_SOURCE_PACKAGE/configure --prefix=$INSTALL_PATH $CONFIGURATION_OPTIONS
make $PARALLEL_MAKE
#make check
make install

echo 'Success!'
