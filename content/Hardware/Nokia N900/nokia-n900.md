# Nokia n900
## About
The nokia n900 is an omap3-based smartphone which is shipped with maemo.
It use uboot as boot-loader and for sure a linux kernel.
maemo is based on debian, so you'll have a real command line, a
package-manager and everything a linux fan needs. No problems due software
limitation because everything you need, can be scripted by yourself.

    Processor:	 	TI Omap3 ARMv7 Processor rev 3 (v7l) 500 Mhz
    Hardware:		Nokia RX-51 board
    Board Layout:	omap3
    Default Kernel: 2.6.28.10

    Processor	: ARMv7 Processor rev 3 (v7l)
    BogoMIPS	: 499.92
    Features	: swp half thumb fastmult vfp edsp thumbee neon vfpv3 
    CPU implementer	: 0x41
    CPU architecture: 7
    CPU variant	: 0x1
    CPU part	: 0xc08
    CPU revision	: 3

    Hardware	: Nokia RX-51 board
    Revision	: 2204
    Serial		: 0000000000000000

    Linux Nokia-N900 2.6.28.10-power50 #1 PREEMPT Sun Mar 18 20:10:56 EET 2012 armv7l unknown

    mtd0: 00020000 00020000 "bootloader"
    mtd1: 00060000 00020000 "config"
    mtd2: 00040000 00020000 "log"
    mtd3: 00200000 00020000 "kernel"
    mtd4: 00200000 00020000 "initfs"
    mtd5: 0fb40000 00020000 "rootfs"

## Flashing
To Flash the n900 you'll have to download the tools and firmware first.

- [Flasher](http://tablets-dev.nokia.com/maemo-dev-env-downloads.php)
- [Firmware](http://tablets-dev.nokia.com/nokia_N900.php)

### eMMC

1. Flash the emmc image: `/path/to/flasher -F <emmc-image>.bin -f`
2. Hold down the "u" key on the phone
3. Connect the phone to the PC

### Firmware

1. Flash the firmware image `/path/to/flasher -F <firmware-image>.bin -f -R`
2. Hold down the "u" key on the phone
3. Connect the phone to the PC

## extra-repository (maemo)
Go to the Application Manager and create a new entry as following:

    catalog name: extras
    web address: http://repository.maemo.org/extras 
    distribution: (empty)
    components: free non-free

### kernel
I really recommend to install the power-user kernel. You can get it after
you've activated the extras repository.

### Root
you can get root access via the gainroot package from the repository.

    package:    gainroot 
    repository: extra

### Tethering
For a wireless hotspot, you can install the mobile-hotspot package from "extras"

    package:    mobile-hotspot
    repository: extra

