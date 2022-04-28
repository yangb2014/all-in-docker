#! /bin/bash
echo `date` "---->> install & setting samba"

sudo yum -y install samba
sudo systemctl start smb
sudo systemctl enable smb

# sudo smbpasswd -a <username>
# sudo vi /etc/samba/smb.conf
