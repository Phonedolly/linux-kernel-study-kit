# build.sh
# created at 2023-08-05
# Install Kernel for 32bit Raspberry Pi OS on Raspberry Pi 4

#!/bin/bash

tar -zxvf out.tar.gz

sudo cp -rv ext4/* /
sudo cp -rv fat32/* /boot

rm -rv ext4 fat32

sudo shutdown -r 0
