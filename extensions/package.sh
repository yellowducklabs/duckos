#!/bin/sh

# @ISSUE should read in from list of implemented archs instead
arch=$(answer "Select an arch: x86, rpi: " "x86")
if [[ ! -d archs/$arch ]]
  then echo "Invalid arch chosen. Aborting."
    exit
fi

read -r -p "Package name: " pkg_name

pkg=/tmp/duck-package
dest=$pkg/home/duck

# Pack up node
mkdir -p $dest
cp -rp $pkg_name $dest

# Fix permissions
sudo chown -R 0:0 $pkg/
# Given we're booting with the tc user=duck bootcode, uid=1000, gid=50 (staff)
# Thus set required uid/gid for the contents of our duck home dir
sudo chown -R 1000:50 $dest

# Create our dest folder if not present
mkdir -p $arch/

# Package up as per tc docs
rm $arch/duck-$pkg_name.tcz
mksquashfs $pkg duck-$pkg_name.tcz

# Cleanup
sudo rm -rf $pkg
