#!/bin/sh

source utils.sh

# @ISSUE This needs to be dynamic, currently hardcoded to the local build VM
DUCKHOST=10.0.1.28
# @ISSUE should read in from list of implemented archs instead
ARCH=x86

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

exit;

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
