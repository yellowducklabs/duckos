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
Insert SD into Pi, connect network cable and turn on.

After a few seconds, run duck push in your git project folder
```
---> Looking for ducks...
Please enter the device IP (hit enter to use 11.22.33.44):
---> Pushing master branch...
...
---> Building App...
---> Deploying App...
---> Application deployed

To duck@11.22.33.44:app
 * [new branch]      master -> master
```
