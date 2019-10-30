# Debootstrap
## Cross
Creating rootfs-tarball for foreign architecture:

    debootstrap --foreign --no-check-gpg --arch=armhf testing /debian-armhf http://ftp.debian.org/debian/ 

Boot the target and run the second stage:

    /debootstrap/debootstrap --second-stage

## Native
creating rootfs-tarball for native architecture:

    debootstrap --no-check-gpg testing /debian http://ftp.debian.org/debian/ 


## Ubuntu

    debootstrap trusty ./trusty http://archive.ubuntu.com/ubuntu/


# apt-get source
build packages out of deb-src repositories:

    apt-get source <package>
    cd <package>/
    vim <stuff>
    apt-get -b source <package>
    dpkg -i <package>
