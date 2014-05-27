#!/bin/sh

# Generate SSH keys
ssh-keygen -A

# Respond to broadcasts from duck find
sysctl -w net.ipv4.icmp_echo_ignore_broadcasts=0

# Start SSH Daemon
/usr/local/sbin/sshd &

# Start Quacker
/home/duck/quacker 10002 &

# Add app deployment to .ashrc
echo "ducku deploy app" >> /home/duck/.ashrc
