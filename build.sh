#!/bin/sh

# @ISSUE This needs to be dynamic, currently hardcoded to the local build VM
DUCKHOST=10.0.1.28

# Create our build folder from our templated initrd modifications
sudo rm -rf build
cp -R initrd_duck build

# Copy in duck, ducku and node binaries
mkdir -p build/home/duck/duck
cp duck build/home/duck/duck/
cp ducku build/home/duck/duck/
cp -r sources/rpi/node build/home/duck/

# The initrd overrides we're packaging should be owned by root
sudo chown -R 0:0 build/
# Given we're booting with the tc user=duck bootcode, uid=1000, gid=50 (staff)
# Thus set required uid/gid for the contents of our duck home dir
sudo chown -R 1000:50 build/home/duck

# Pack our initrd modifications
cd build
sudo find . | sudo cpio -o -H newc | gzip -2 > ../duck.gz
cd ..

# Grub doesn't support multiple initrd files, so cat core and duck together and
# use the combined archive instead
cat core.gz duck.gz > combined.gz

scp -o StrictHostKeyChecking=no combined.gz root@$DUCKHOST:/mnt/sda1/boot/core.gz
echo "---> New core.gz installed."

ssh -o StrictHostKeyChecking=no root@$DUCKHOST reboot
