#! /bin/bash
set -e

yum clean all 
yum -y groupinstall "Development Tools" 
yum -y install wget autogen 
yum clean all

echo 'Success!'
