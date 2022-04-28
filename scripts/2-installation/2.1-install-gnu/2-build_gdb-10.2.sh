#! /bin/bash
set -e

GDB_VERSION=gdb-10.2
INSTALL_PATH=/usr/local/$GDB_VERSION
export PATH=$INSTALL_PATH/bin:$PATH

CONFIGURATION_OPTIONS=--with-python='/usr/bin/python2.7'
PARALLEL_MAKE=-j4

# Download packages
wget -nc http://ftpmirror.gnu.org/gnu/gdb/$GDB_VERSION.tar.xz

# Extract everything
for f in *.tar*; do tar xfk $f; done

# prerequisites
sudo yum -y install python python-devel texinfo

# Build & install
mkdir -p build-gdb
cd build-gdb
../$GDB_VERSION/configure --prefix=$INSTALL_PATH $CONFIGURATION_OPTIONS
make $PARALLEL_MAKE
#make check
make install

echo 'Success!'
