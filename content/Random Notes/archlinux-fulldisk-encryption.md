# Install Archlinux with FullDisk Encryption

## Setup the live environment
    loadkeys de-latin1
    wifi-menu

## Setup the partitions

    cfdisk /dev/sda
    mkfs.ext4 /dev/sda1 -L boot
    cryptsetup -c aes-xts-plain64 -y -s 512 luksFormat /dev/sdX2
    cryptsetup luksOpen /dev/sda2 rootfs
    mkfs.ext4 /dev/mapper/rootfs -L system

    mount /dev/mapper/rootfs /mnt
    mkdir /mnt/boot
    mount /dev/sda1 /mnt/boot

## Main installation

    pacstrap /mnt base base-devel
    pacstrap /mnt grub-bios
    pacstrap /mnt <your software>

    genfstab -p -U /mnt > /mnt/etc/fstab

## System configuration

    arch-chroot /mnt
    vi /etc/locale.gen
      de_DE.UTF-8 UTF-8
      en_GB.UTF-8 UTF-8
    locale-gen
    echo LANG=de_DE.UTF-8 > /etc/locale.conf
    export LANG=de_DE.UTF-8

    vi /etc/vconsole.conf
      KEYMAP="de-latin1-nodeadkeys"
      FONT=Lat2-Terminus16
      FONT_MAP=

    ln -s /usr/share/zoneinfo/Europe/Berlin /etc/localtime
    echo HOSTNAME > /etc/hostname

## Modify the initramfs
 
    vi /etc/mkinitcpio.conf
    - Add "keymap" and "encrypt" before "filesystems" in the HOOKS
    mkinitcpio -p linux

## Bootloader

    grub-install /dev/sda
    vi /etc/default/grub
      GRUB_CMDLINE_LINUX="cryptdevice=/dev/sda2:rootfs"
    grub-mkconfig -o /boot/grub/grub.cfg

## Finish the installation

    passwd
    exit
    reboot
