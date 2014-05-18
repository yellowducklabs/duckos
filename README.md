DuckOS
===================

A very small Operating System and toolkit aimed at providing the simplest zero-to-hero experience for bringing code to a device or VM.

Install
-----

To install duck on your host computer, run:

```curl duckos.io/install | sh```

Write
------------

Insert an SD card on host and run `duck write`

```
---> Downloading latest DuckOS...
Select disk device (data will be destroyed): /dev/disk2
---> Writing DuckOS to /dev/disk2...
---> DuckOS install complete!
```

Deploy
--------

```
$ echo 'Hello world!' > app.js
$ git init; git add app.js
$ git commit -m "First release"
$ git push duck@10.0.1.15:app master
---> Building App...
---> Deploying App...
---> Application deployed
```
