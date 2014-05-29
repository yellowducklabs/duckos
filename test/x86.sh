#!/bin/sh
# set -x

# @ISSUE This needs to be dynamic, currently hardcoded to the local build VM
HOST=$(duck find-quiet)

# Remove the host key given host keys change each build
ssh-keygen -R $HOST

# Package our test app
tar czvf app.tar.gz -C app/ .

# Use private key and skip host checking as keys change each build
args="-i ../duckauth.priv -o StrictHostKeyChecking=no "

# Manually deploy it
cat app.tar.gz | ssh $args duck@$HOST receive-gzip app

sleep 1

curl $HOST

echo "---> Issuing reboot..."
ssh $args root@$HOST reboot

echo "---> Waiting 10 seconds..."
sleep 10

echo "---> Querying with curl..."
curl $HOST
