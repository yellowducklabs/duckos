#!/bin/sh

echo "Not using this, just for reference."
exit;

# Set root pass
CRYPTEDPASS=$(perl -e 'print crypt("duckos","quack")')
sed -i -e "s#^root:[^:]*:#root:$CRYPTEDPASS:#" root/etc/shadow

# Mount memory card
install -d -m 0755 root/boot
echo '/dev/mmcblk0p1 /boot vfat defaults 0 0' >> root/etc/fstab

# Add Firmware for rpi
cp stuff/bootcode.bin boot/
cp stuff/start.elf boot/
cp stuff/fixup.dat boot/

# Some kernel magic
echo 'dwc_otg.lpm_enable=0 console=ttyAMA0,115200 kgdboc=ttyAMA0,115200 console=tty1 elevator=deadline rootwait root=/dev/mmcblk0p2 rootfstype=ext4' > boot/cmdline.txt


