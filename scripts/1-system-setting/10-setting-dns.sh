#! /bin/bash
echo `date` "---->> setting DNS servers"

RESOLV_FILE="/etc/resolv.conf"

if [ `grep -c "114.114.114.114" $RESOLV_FILE` -eq '0' ]; then
    sudo sed -i '$a\\nnameserver  114.114.114.114' $RESOLV_FILE
fi

if [ `grep -c "8.8.8.8" $RESOLV_FILE` -eq '0' ]; then
    sudo sed -i '$a\\nnameserver  8.8.8.8' $RESOLV_FILE
fi
