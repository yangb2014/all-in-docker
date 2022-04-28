#! /bin/bash
set -e
trap 'previous_command=$this_command; this_command=$BASH_COMMAND' DEBUG
trap 'echo FAILED COMMAND: $previous_command' EXIT

#-------------------------------------------------------------------------------------------
# See: 
# http://preshing.com/20141119/how-to-build-a-gcc-cross-compiler
# https://www.cnblogs.com/pengdonglin137/p/11565115.html
# https://solarianprogrammer.com/2018/05/06/building-gcc-cross-compiler-raspberry-pi/
# https://gcc.gnu.org/wiki/InstallingGCC
#-------------------------------------------------------------------------------------------

TARGET=aarch64-linux-gnu
LINUX_ARCH=arm64
GCC_INSTALL_PATH=/opt/gcc-10.2.0-aarch64
GLIBC_INSTALL_PATH=$GCC_INSTALL_PATH/$TARGET
CONFIGURATION_OPTIONS="--disable-multilib" # --disable-threads --disable-shared
PARALLEL_MAKE=-j$(nproc)
BINUTILS_VERSION=binutils-2.27
LINUX_KERNEL_VERSION=linux-3.10
GCC_VERSION=gcc-10.2.0
GLIBC_VERSION=glibc-2.17
GMP_VERSION=gmp-6.1.0
MPFR_VERSION=mpfr-3.1.4
MPC_VERSION=mpc-1.0.3
ISL_VERSION=isl-0.18
export PATH=$GCC_INSTALL_PATH/bin:$PATH

# Download packages
wget -nc http://ftpmirror.gnu.org/binutils/$BINUTILS_VERSION.tar.gz
wget -nc http://ftpmirror.gnu.org/gcc/$GCC_VERSION/$GCC_VERSION.tar.xz
wget -nc https://www.kernel.org/pub/linux/kernel/v3.x/$LINUX_KERNEL_VERSION.tar.xz --no-check-certificate
wget -nc http://ftpmirror.gnu.org/glibc/$GLIBC_VERSION.tar.xz
wget -nc http://ftpmirror.gnu.org/gmp/$GMP_VERSION.tar.xz
wget -nc http://ftpmirror.gnu.org/mpfr/$MPFR_VERSION.tar.xz
wget -nc http://ftpmirror.gnu.org/mpc/$MPC_VERSION.tar.gz
wget -nc ftp://gcc.gnu.org/pub/gcc/infrastructure/$ISL_VERSION.tar.bz2

# Extract everything
for f in *.tar*; do tar xfk $f; done

# Dealing with Build Errors
# glibc-2.17 configure: "$critic_missing gcc"o
if [ $GLIBC_VERSION = "glibc-2.17" ]; then
    sed -i '4912{s/\[5-9\]\.\*/[5-9].* | [1-9][0-9]*/}' ./$GLIBC_VERSION/configure
fi
# gcc-10_2_0/libsanitizer/asan/asan_linux.cpp: ‘PATH_MAX’ undeclared
if [ $GCC_VERSION = "gcc-10.2.0" ]; then
    sed -i '78a\#ifndef PATH_MAX \n#define PATH_MAX 4096 \n#endif \n' ./$GCC_VERSION/libsanitizer/asan/asan_linux.cpp
fi

# Make symbolic links
cd $GCC_VERSION
ln -sf `ls -1d ../gmp-*/` gmp
ln -sf `ls -1d ../mpfr-*/` mpfr
ln -sf `ls -1d ../mpc-*/` mpc
ln -sf `ls -1d ../isl-*/` isl
cd ..

# Step 1. Binutils
mkdir -p build-binutils
cd build-binutils
../$BINUTILS_VERSION/configure --prefix=$GCC_INSTALL_PATH --target=$TARGET $CONFIGURATION_OPTIONS
make $PARALLEL_MAKE
make install
cd ..

# Step 2. Linux Kernel Headers
cd $LINUX_KERNEL_VERSION
make ARCH=$LINUX_ARCH INSTALL_HDR_PATH=$GCC_INSTALL_PATH/$TARGET headers_install
cd ..

# Step 3. C/C++ Compilers
mkdir -p build-gcc
cd build-gcc
../$GCC_VERSION/configure --prefix=$GCC_INSTALL_PATH --target=$TARGET --enable-languages=c,c++ $CONFIGURATION_OPTIONS
make $PARALLEL_MAKE all-gcc
make install-gcc
cd ..

# Step 4. Standard C Library Headers and Startup Files
mkdir -p build-glibc
cd build-glibc
echo "localtime-file := /etc/localtime" > configparms
../$GLIBC_VERSION/configure --prefix=$GLIBC_INSTALL_PATH --build=$MACHTYPE --host=$TARGET --target=$TARGET --with-headers=$GCC_INSTALL_PATH/$TARGET/include $CONFIGURATION_OPTIONS --disable-sanity-checks libc_cv_forced_unwind=yes
make install-bootstrap-headers=yes install-headers
make $PARALLEL_MAKE csu/subdir_lib
install csu/crt1.o csu/crti.o csu/crtn.o $GLIBC_INSTALL_PATH/lib
$TARGET-gcc -nostdlib -nostartfiles -shared -x c /dev/null -o $GLIBC_INSTALL_PATH/lib/libc.so
touch $GLIBC_INSTALL_PATH/include/gnu/stubs.h
cd ..

# Step 5. Compiler Support Library
cd build-gcc
make $PARALLEL_MAKE all-target-libgcc
make install-target-libgcc
cd ..

# Step 6. Standard C Library & the rest of Glibc
cd build-glibc
make $PARALLEL_MAKE
make install
cd ..

# Step 7. Standard C++ Library & the rest of GCC
cd build-gcc
make $PARALLEL_MAKE all
make install
cd ..

trap - EXIT
echo 'Success!'
