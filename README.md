# docker-netlogger-rpi
Netlogger in a container running a Raspberrypi

You will need to download the linux tarball from the netlogger site:
https://www.netlogger.org/
and place it in the the folder with the Dockerfile.

This uses box64 to run the 64 bit linux binary on the 64 bit arm architecture.
You can use the include bash script 'netlogger' to launch the application.
A sample netlogger.desktop and icon files are included so you can launch it from the application menu.
By default it will run as the current user and mount the user's home directory.

You will need to build the kd2qar/box64 image to use as a base image for this.

To build run the makefile:
make
and then run the 'neglogger' script to launch the container and the application.

...
