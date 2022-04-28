#! /bin/bash
set -e

# reference:
#   https://www.itzgeek.com/how-tos/linux/centos-how-tos/install-gnome-gui-on-centos-7-rhel-7.html

sudo yum -y groupinstall "GNOME Desktop" "Graphical Administration Tools"

# systemctl set-default graphical.target
# systemctl set-default multi-user.target

echo 'Success!'
