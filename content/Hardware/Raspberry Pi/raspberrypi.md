# Raspberry Pi

## Notes

    About:	http://de.wikipedia.org/wiki/Raspberry_Pi
    CPU:	Broadcom BCM 2835 700Mhz ARM1176JZF-S
    RAM:	256 MB

## Sources & Links

- [firmware + libraries](https://github.com/raspberrypi/firmware)
- [kernel](https://github.com/raspberrypi/linux)
- [tools, e.g imagetool-uncompressed.py](https://github.com/raspberrypi/tools)
- [stage tarball](http://distfiles.gentoo.org/releases/arm/autobuilds/current-stage3-armv6j_hardfp)

## Partitioning

    mmcblk0p1:
      type: vfat	
      flags: boot

    mmcblk0p2 
      type: ext4
      flags: -

## Boot

- bootcode.bin
- loader.bin
- start.elf
- cmdline.txt: `root=/dev/mmcblk0p2 rootdelay=3`

## Kernel

    make ARCH=arm bcmrpi_cutdown_defconfig 
    make ARCH=arm CROSS_COMPILE=/usr/bin/armv6j-hardfloat-linux-gnueabi- oldconfig
    make ARCH=arm CROSS_COMPILE=/usr/bin/armv6j-hardfloat-linux-gnueabi- menuconfig
    make ARCH=arm CROSS_COMPILE=/usr/bin/armv6j-hardfloat-linux-gnueabi- -j5
    make ARCH=arm CROSS_COMPILE=/usr/bin/armv6j-hardfloat-linux-gnueabi- INSTALL_MOD_PATH=/path/to/rootfs modules_install

    imagetool-uncompressed.py /path/to/kernel/arch/arm/boot/image 
    cp kernel.img /boot

## Gentoo
### CFLAGS

    CFLAGS="-O2 -march=armv6j -mfpu=vfp -mfloat-abi=hard"
    CXXFLAGS="${CFLAGS}"

### Toolchain

    crossdev -S armv6j-hardfloat-linux-gnueabi
