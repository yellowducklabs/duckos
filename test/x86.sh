#!/bin/sh
set -x

# @ISSUE This needs to be dynamic, currently hardcoded to the local build VM
HOST=10.0.1.28

# Remove the host key given host keys change each build
ssh-keygen -R $HOST


tar czvf app.tar.gz -C app/ .

# Use private key and skip host checking as keys change each build
args="-i ../duckauth.priv -o StrictHostKeyChecking=no "

cat app.tar.gz | ssh $args duck@$HOST receive-gzip app

