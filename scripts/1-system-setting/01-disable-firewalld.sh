#! /bin/bash
echo `date` "---->> stop & disable firewalld.service"

# Authentication is required to manage system service or unit files... if 'sudo' missing
sudo systemctl stop firewalld.service
sudo systemctl disable firewalld.service
