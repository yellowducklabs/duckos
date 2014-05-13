#!/bin/bash

source utils.sh

# @ISSUE should read in from list of implemented archs instead
ARCH=$(answer "Select an arch: x86, rpi: " "x86")
if [[ ! -d archs/$ARCH ]]
  then echo "Invalid arch chosen. Aborting."
    exit
fi

# Create our build folder from our templated initrd modifications
sudo rm -rf build
cp -R initrd_duck build

# Copy in duck, ducku and node binaries
mkdir -p build/home/duck/duck
cp duck build/home/duck/duck/
cp ducku build/home/duck/duck/
cp -r sources/$ARCH/node build/home/duck/

# Set up SSH keys for root and duck
if [[ -f ~/.ssh/id_rsa.pub ]]
  then SSH_PUB_PATH=$(answer "Select pub key to install (~/.ssh/id_rsa.pub): " "$HOME/.ssh/id_rsa.pub")
    SSH_AUTHORIZED_KEY='command="/usr/local/bin/ducku $SSH_ORIGINAL_COMMAND" '`cat $SSH_PUB_PATH`
    echo $SSH_AUTHORIZED_KEY >> build/home/duck/.ssh/authorized_keys
    echo $SSH_AUTHORIZED_KEY >> build/root/.ssh/authorized_keys
fi

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
cat archs/$ARCH/core.gz duck.gz > combined.gz
echo "---> combined.gz built"

# Run the arch specific build
echo "---> Running $ARCH build script"
sh archs/$ARCH/build
echo "---> $ARCH build complete"
