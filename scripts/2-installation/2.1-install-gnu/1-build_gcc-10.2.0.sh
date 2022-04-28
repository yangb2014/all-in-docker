#! /bin/bash
set -e

GCC_VERSION=gcc-10.2.0
GMP_VERSION=gmp-6.1.0
MPFR_VERSION=mpfr-3.1.4
MPC_VERSION=mpc-1.0.3
ISL_VERSION=isl-0.18

INSTALL_PATH=/usr/local/$GCC_VERSION
export PATH=$INSTALL_PATH/bin:$PATH

CONFIGURATION_OPTIONS="--disable-multilib" # --disable-threads --disable-shared
PARALLEL_MAKE=-j$(nproc)

# Download packages
wget -nc http://ftpmirror.gnu.org/gcc/$GCC_VERSION/$GCC_VERSION.tar.xz
wget -nc http://ftpmirror.gnu.org/gmp/$GMP_VERSION.tar.xz
wget -nc http://ftpmirror.gnu.org/mpfr/$MPFR_VERSION.tar.xz
wget -nc http://ftpmirror.gnu.org/mpc/$MPC_VERSION.tar.gz
wget -nc ftp://gcc.gnu.org/pub/gcc/infrastructure/$ISL_VERSION.tar.bz2

# Extract everything
for f in *.tar*; do tar xfk $f; done

# Make symbolic links
cd $GCC_VERSION
ln -sf `ls -1d ../gmp-*/` gmp
ln -sf `ls -1d ../mpfr-*/` mpfr
ln -sf `ls -1d ../mpc-*/` mpc
ln -sf `ls -1d ../isl-*/` isl
cd ..

# Build & install
mkdir -p build-gcc
cd build-gcc
../$GCC_VERSION/configure --prefix=$INSTALL_PATH --enable-checking=release --enable-languages=c,c++ $CONFIGURATION_OPTIONS
make -j$(nproc)
make check
make install

echo 'Success!'
