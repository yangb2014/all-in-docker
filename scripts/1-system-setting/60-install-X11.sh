#! /bin/bash
echo `date` "---->> install & setting X11"

# https://www.itzgeek.com/how-tos/linux/centos-how-tos/install-gnome-gui-on-centos-7-rhel-7.html
sudo yum -y groupinstall "GNOME Desktop" "Graphical Administration Tools"

# systemctl set-default graphical.target
# systemctl set-default multi-user.target
