# CentOS Development Tools dockerfile
#
# docker build --rm -t centos7-devel .
# docker run -it centos7-devel /bin/bash

FROM centos:7.9.2009

# install development tools
RUN yum clean all \
 && yum -y groupinstall "Development Tools" \
 && yum -y install wget autogen \
 && rm -rf /var/cache/yum/*

# environment
ENV PATH=$PATH \
    LD_LIBRARY_PATH=/usr/local/lib:/usr/lib
RUN mkdir -p /home/build
WORKDIR /home/build

# gcc-10.2.0/glibc2.17 for aarch64
COPY build_cross_gcc-10.2.sh .
RUN source ./build_cross_gcc-10.2.sh && rm -rf /home/build/* /home/build/*.*

# gcc-10.2.0 for x86
#COPY build_gcc-10.2.sh ./x86_64/
#RUN source ./x86_64/build_gcc-10.2.sh && rm -rf /home/build/x86_64/*

# gdb-10.2.0 ？
