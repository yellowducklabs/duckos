#!/bin/sh

# Generate SSH keys
ssh-keygen -A

# Start SSH Daemon
/usr/local/sbin/sshd
