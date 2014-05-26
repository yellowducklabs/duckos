#!/bin/sh
set -x

# @ISSUE This needs to be dynamic, currently hardcoded to the local build VM
HOST=10.0.1.28

ssh-keygen -R $HOST

gzip -rc app > app.gz

# Use private key and skip host checking as keys change each build
args="-i ../duckauth.priv -o StrictHostKeyChecking=no "

cat app.gz | ssh $args duck@$HOST receive-gzip app

