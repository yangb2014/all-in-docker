#! /bin/bash
echo `date` "---->> stop & disable SELinux"

# disable SELinux temporarily
sudo setenforce 0
getenforce

# disable SELinux permanently
# /etc/selinux/config: SELINUX=disabled
sudo sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config

