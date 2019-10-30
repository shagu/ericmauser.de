# Create a bootable Windows7 USB stick under Linux

    depends: ntfs3g

## create the partition

    parted /dev/sdX
    mklabel msdos
    mkpart primary ntfs 1 -1
    set 1 boot on
    quit

    mkfs.ntfs -f /dev/sdX1

## compile and install the bootloader

    # download http://ms-sys.sourceforge.net/
    tar xvzf ms-sys-2.*.tar.gz
    cd ms-sys-2.*
    make
    cd bin
    ./ms-sys -7 /dev/sdX

## copy the files

    mkdir -p /mnt/usb
    mkdir -p /mnt/iso

    mount -o loop /path/to/iso /mnt/iso
    mount /dev/sdX1 /mnt/usb

    cp -av /mnt/iso* /mnt/usb

## finish

    sync
    umount /mnt/usb
    umount /mnt/iso
