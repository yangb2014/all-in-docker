#! /bin/bash
set -e

yum clean all 
yum -y groupinstall "Development Tools" 
yum -y install cmake
yum -y install wget curl 
yum -y install autogen 
yum -y install openssl openssl-devel openssl-libs 

yum clean all

echo 'Success!'
