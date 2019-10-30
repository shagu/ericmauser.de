# Hercules eCafe
## About
The eCafé is a ARM-Cortex-A8 based netbook manufactured by Hercules. It's a Freescale CPU from the i.MX51 Series.
By default it comes with an ubuntu netbook desktop which is modified by hercules and supplemented by some tools like the eCafe Webcam viewer.
The package repositories are hosted by Hercules. It has a resolution of 1024x600 and the battery runs at least for over 20 hours with my default vim-usage.
Personally, i'm not a ubuntu-fan, so one of the first things i did, was to try to get a working arch/gentoo on that great thing.

    Processor:	ARMv7 800 Mhz
    Hardware:	Hercules MX51 eCAFE
    Board:		IMX51
    Resolution:	1024x600
    Graphic:	IMX51
    Backlight:	255 Steps
    Battery:    For me, more than 20 Hours
    Storage:
    - 8 GB iNAND (eMMC)
    - 1 internal MMC Card Slot
    - 1 external MMC Card Slot

## Preparation

First of all, we need to fetch all the sources. These are the following:

 1. [Cross Compile Toolchain (gcc-4.4.4-glibc-2.11.1-multilib-1.0-1.i386.rpm)](http://package.ecafe.hercules.com/Sources/)
 2. [Kernel Sources (linux-2.6.35.4-ecafe-v4C_src.tar.gz)](http://package.ecafe.hercules.com/Sources/)
 3. [SDK-Documentation (Hercules%20eCAFE-SlimEX-HD-SDK_V1.0.pdf)](http://package.ecafe.hercules.com/Sources/)
 4. [System Restore SD-Image (at the bottom of the page)](http://ecafe.hercules.com/us/download-and-services/)

On the System Restore SD Image is a tarball of the ubuntu installation. Extract it to a directory you want, on the Host of course. 
Because later, we will need some firmware and blobs of it.

### Building the install environment
As we need something to install our later described rootfs-images, we start installing the System Restore SD Image. Plug a free SD Card into your Cardreader of your host system.
unpack the Image and DD it to your SD

    dd if=/path/to/your/restore-image of=/dev/mmcblk0 bs=4M

try to mount it, and create a directory in the root called /stages. We will need this one, to copy our root images to it.


## Kernel
In fact that we may need additional kernel modules like a device encryption (dm-crypt, xts, aes, ...) and some additional filesystems we should build an own kernel. 
In the eCafe SDK Documentation, it's perfectly described how to do that. But there is a point where i don't agree. Since the SDK seems to be outdated, they write about to use the Kernel with the ending -v2_src. 
Maybe it will work for you with v2_src greatly. But I was not able to get the audio working with the v2_src. v4C_src instead brings a specific ecafe alsa module which works great. 
So if you want a running system without driver problems, I recommend the v4C_src kernel sources.

### Toolchain
Now we need to install the toolchain, we've downloaded previously. Since the Toolchain comes as .rpm, we need to convert it to a file we can easily unpack. 
For me as a gentoo user, `rpm2targz` did the trick. After conversion, we just unpack the toolchain to /.

    tar xfvz /path/to/toolchain.tar.gz -C /

now unpack the kernel sources too.

    tar xfvz /path/to/kernel/sources.tar.gz

### Building the kernel
We now enter the kernel directory and set the following Environment variables:

    export ARCH=arm 
    export CROSS_COMPILE=/opt/freescale/usr/local/gcc-4.4.4-glibc-2.11.1-mulitlib-1.0/arm-fsl-Linux-gnueeabi/bin//arm-fsl-Linux-gnueabi-
    export INSTALL_MOD_PATH=./

to get a working ecafe config, just type:

    make ecafe_defconfig

With the fundament of this defconfig, we can add the stuff we need and removed some "trash" like the built-in ntfs support and such.

NOTE: since most operating systems switched to devtmpfs which is maintained by the kernel,
we have to activate it in the kernel.
I Found it in `Device Drivers -> Generic Driver Options`:

    [*] Maintain a devtmpfs filesystem to mount at /dev
    [*]   Automount devtmpfs at /dev, after the kernel mounted the rootfs

to configure type:

    make menuconfig

After we finished our kernel configuration, we do a full build of it. (you may need u-boot-utils)

    make uImage
    make modules
    make modules_install

now we copiy the files (uImage + modules) to the restore-SD (in my case /stages/kernel). 
You can locate the uImage in ./arch/arm/boot/.

#### Installation
To install the kernel, boot the rescue system, and DD the Kernel Image to /dev/mmcblk0 (which is the NAND) and the modules to your rootfs /lib. 
You can safely remove the old lib/modules from your previous ubuntu version. If you know, that your kernel will run correctely :)

    dd if=uImage of=/dev/mmcblk0 bs=1M seek=1

## Linux

### Debian
For Debian, wen need to install debootstrap on the host (for gentoo users: emerge -av debootstrap).
Now we run the debootstrap command to checkout the testing. Testing should be the choice because stable doesn't have armhf packages:

    debootstrap --foreign --no-check-gpg --arch=armhf testing /debian-ecafe http://ftp.debian.org/debian/

This may take a while (about 1-2minutes depends on your internet connection). Tarball it!:)

    cd debian-ecafe
    tar cfjp ../debian-rootfs.tar.bz2 .

Let bring it to the SD Rescue Image. Copy your tarball to your SD-Rescue Image to the path: /stages.
Now perform an install as described later. But after you unpacked the rootfs to your NAND, you have to chroot it and run the second stage:

    chroot /mnt/rootfs /bin/bash
    /debootstrap/debootstrap --second-stage
    exit

This will finish the debian distribution. Now go on as usual.

### Gentoo
Gentoo is quite easy if you don't plan to crosscompile with your host. Download the stage3 you want.
I recommend hardfloated. Copy it to your SD-Rescue to the /stages folder. 
You can find 'em here: [gentoo autobuids](http://distfiles.gentoo.org/releases/arm/autobuilds/)

### Archlinux
Archlinux is quite easy. Download archlinuxarm's stage3 here: [ArchLinuxARM-2012.06-omap-smp-rootfs.tar.gz](http://archlinuxarm.org/os/omap/)
It took the omap, because its armv7, and as we don't use archlinux's boot mechanisms (uboot/kernel/etc) we don't care in the fact that omap != imx.
Let's copy it to our SystemRescues SD to path: /stages/


## Install via SystemRescue
Boot your SystemRescue SD. Now we can install our Linux:

    mkfs.ext4 /dev/mmcblk0p1
    mkdir /mnt/rootfs
    mount /dev/mmcblk0p1 /mnt/rootfs
    tar xfjp /stages/<distribution>-rootfs.tar.bz2 -C /mnt/rootfs

Install the kernel with:

    dd if=/stages/kernel/uImage of=/dev/mmcblk0 bs=1M seek=1

and copy the modules:

    cp /stages/kernel/lib /mnt/rootfs -Rf

finish the installation:

    umount /mnt/rootfs
    sync

Reboot the eCafe, set the DIP-switch back to internal boot. You should now see your Kernel booting into your rootfs :)

## Troubleshooting
### Wireless
The Wireless Network device on the eCafé won't be able to come up after a default installation.
I'd seen a device called ra0 if I typed "ifconfig -a" as root. But when hit "ifconfig ra0 up" to bring it up, it gave me an error like this:

    SCSIOFLAGS : Operation not permitted.

That's because the correct driver is needed to bring it up. It's not just a Firmware+Kernel thing. I had to use the driver package from ralink for my 2.6.35 Kernel.
Just Copy the /etc/Wireless folder from the ubuntu-tarball you've extracted previously to your own Installation. Because the ralink driver needs the File in /etc/Wireless to come up correctly.

### Udev
Udev makes some problems because, our kernel is quite to old for newer udev versions.
But theres a patch available, which patches udev to use the old commands to the kernel.

#### Archlinux
install udev-oxnas, should do the trick. But it can make you crazy on pacman updates.

#### Debian
build your own udev version, and patch it with [pre-accept4-kernel.patch](https://github.com/archlinuxarm/PKGBUILDs/blob/01d2c127d2501088cf4f1b971392e6561e2ab11f/core/udev-oxnas/pre-accept4-kernel.patch).
If the link is dead, you have to google for "udev oxnas patch github".

    apt-get source udev
    cd udev*/udev
    vim udev-ctrl.c
    # patch it manually, there are only 4 parts :)
    cd ../..
    apt-get -b source udev
    dpkg -i udev_*.deb

#### Gentoo
patch it your own, or mask the new udev versions. The Patch can be found [here](https://github.com/archlinuxarm/PKGBUILDs/blob/01d2c127d2501088cf4f1b971392e6561e2ab11f/core/udev-oxnas/pre-accept4-kernel.patch)
or google for "udev oxnas patch github".

### Accelerated Graphics on the eCafé
I have to say that, until now, I do not feel a great difference between fbdev driver and the imx driver.
But that's maybe because of the fact, that I still do not use the accelerated gstreamer drivers.
I'm still satisfied with my mplayer sdl output.

    mplayer -vo sdl -autosync 30 -framedrop -cache 8192

NOTE: I use sdl because xv seems to be buggy in some cases, and sdl let me scale the video.
On gentoo instead, i wasn't yet able to build the i.MX drivers. On this point, every help is appreciated.
On Archlinux it's quite easy to install the i.MX51 Accelerated video drivers. I just hit 

    pacman -S xf86-video-imx

in the console. After that, I gave the GL-device some other permissons. To recreate this permissons I've added this line to local.start:

    chmod 777 /dev/gsl_kmod

In the next step, i downloaded the ubuntu libkgsl-imx package, because there is no archlinux package for this in the repositories.

    wget http://packages.efikamx.info/pool/main/i/imx-graphics/libkgsl-imx_1.0.3-20110310_armel.deb

Unpacked it, and moved the libkgsl.so.1.0 from ./usr/lib to /usr/lib 
then i created two symlinks for compatibility with some other packages.

    cd /usr/lib
    ln -s libkgsl.so.1.0 libkgsl.so.1
    ln -s libkgsl.so.1.0 libkgsl.so
