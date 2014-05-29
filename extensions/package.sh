#!/bin/bash

set -ue

answer() {
  read -r -p "$1" response
  case $response in
    "")
      echo $2
      ;;
    *)
      echo $response
      ;;
  esac
}

confirm() {
  # call with a prompt string or use a default
  read -r -p "${1:-Are you sure?} [y/N] " response
  case $response in
    [yY][eE][sS]|[yY])
      true
      ;;
    *)
      false
      ;;
  esac
}

# @ISSUE should read in from list of implemented archs instead
arch=$(answer "Select an arch: x86, rpi: " "x86")
if [[ ! -d ../sources/$arch ]]
  then echo "Invalid arch chosen. Aborting."
    exit
fi

read -r -p "Package name: " pkg_name

echo "---> Building from ../sources/$arch/$pkg_name..."

tmp=/tmp/duck-package
dest=$tmp/usr/local

# Pack up node
mkdir -p $dest
cp -rp ../sources/$arch/$pkg_name/bin $dest
cp -rp ../sources/$arch/$pkg_name/include $dest
cp -rp ../sources/$arch/$pkg_name/lib $dest

# Fix permissions
sudo chown -R 0:0 $tmp/
# Given we're booting with the tc user=duck bootcode, uid=1000, gid=50 (staff)
# Thus set required uid/gid for the contents of our duck home dir
sudo chown -R 1000:50 $dest

# Create our dest folder if not present
mkdir -p $arch/

echo "---> Packing with mksquashfs..."

# Package up as per tc docs
rm -f $arch/duck-$pkg_name.tcz
mksquashfs $tmp $arch/duck-$pkg_name.tcz

# Cleanup
sudo rm -rf $tmp

echo "---> Built to $arch/duck-$pkg_name.tcz"

if confirm "Copy to archs/$arch/persistent/tce/optional?"; then
  cp $arch/duck-$pkg_name.tcz ../archs/$arch/persistent/tce/optional
fi
