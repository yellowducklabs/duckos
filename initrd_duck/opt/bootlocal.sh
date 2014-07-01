#!/bin/sh

# Generate SSH host keys if they don't exist
if [ ! -f /usr/local/etc/ssh/ssh_host_key ]; then
  ssh-keygen -A 2>&1 > /dev/null
  filetool.sh -b 2>&1 > /dev/null
fi

# Respond to broadcasts from duck find
sysctl -w net.ipv4.icmp_echo_ignore_broadcasts=0 2>&1 > /dev/null

# Autoconnect to the first wifi.db entry via DHCP if we have a db file
if [ -f /home/duck/wifi.db ]; then
  wifi.sh -a
fi

# Start SSH Daemon
/usr/local/sbin/sshd &

# Start Quacker
/usr/local/bin/quacker 10002 &

# Add app deployment to .ashrc
echo "ducku execute >/dev/null" >> /home/duck/.ashrc
