# Install Archlinux on Multimedia PC

This describes how to install archlinux with xbmc and hardware video decoding
for an AMD APU (E-350) using the opensource radeon drivers.

## Setup the live environment

    loadkeys de-latin1
    wifi-menu

## Setup partitions

    cfdisk /dev/sda
    mkfs.ext4 /dev/sda1 -L system
    mount /dev/sda1 /mnt

## Main installation

    pacstrap /mnt base base-devel
    pacstrap /mnt syslinux

    genfstab -p -U /mnt > /mnt/etc/fstab
    arch-chroot /mnt

## System configuration

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
    ln -s /dev/null /etc/udev/rules.d/80-net-name-slot.rules
    echo HOSTNAME > /etc/hostname

## Software installation

    pacman -S xorg xorg-xinit xbmc libva-vdpau-driver wicd
    systemctl enable wicd

## Create and setup a new user

    passwd
    useradd eric -m -G users,audio,video,games,network,optical,storage,wheel
    passwd eric
    su -l eric -c "echo xbmc-standalone > /home/eric/.xinitrc"

## Make use of the video decoding on the new OSS radeon drivers

    vi /etc/profile.d/radeon.sh
      export LIBVA_DRIVER_NAME=vdpau
      export VDPAU_DRIVER=r600
    chmod +x /etc/profile.d/radeon.sh

## Bootloader

    syslinux-install_update -i -a -m
    vi /boot/syslinux/syslinux.cfg
      PROMPT 1
      TIMEOUT 50 
      DEFAULT arch

      LABEL arch
          LINUX ../vmlinuz-linux
          APPEND root=/dev/sda1 rw quiet radeon.dpm=1 radeon.audio=1 clocksource=hpet hpet=enable
          INITRD ../initramfs-linux.img

## Finish the installation

    exit
    reboot

## Blu-Ray
for bluray support follow those instructions: [vlc-bluray](http://vlc-bluray.whoknowsmy.name/).
It will make it possible to watch some of the encrypted bluray discs.
