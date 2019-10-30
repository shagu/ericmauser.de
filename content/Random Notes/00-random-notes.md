# Random Notes
## Simple webserver with python2
start a webserver with directory listing in the current directory:
    python2 -m SimpleHTTPServer 8000

## Ubuntu libgl errors
To avoid erros with bumblebee hybrid graphic on 32bit applications (e.g. steam)
do the following:

    sudo vim /etc/ld.so.conf.d/optimus.conf

Add next two lines to file:
    /usr/lib32
    /usr/lib/i386-linux-gnu/mesa

Then execute:
    sudo ldconfig

## Transcode movie to HQ h264 via ffmpeg
map 0 makes sure that all audio tracks will be present in output file aswell.
without "veryslow" profile will be great quality, too.

    ffmpeg -i INPUT.mkv -map 0 -vcodec libx264 -preset veryslow -acodec	libmp3lame OUTPUT.mkv

## h264 hardware encoding with gstreamer

The following command is used to convert any movie to a matroska(mkv) container,
with a h264 video (scaled down to 720p) and faac audio (with a bitrate of 40000).
The whole video encoding is hardware accelerated and requires a working gstreamer-vaapi backend.
The hardware must be able to do h264 encoding (newer intels, nvidia,..)

    gst-launch-1.0 filesrc location="~/input.mp4" ! \
      decodebin name=demux ! \
      videoscale ! "video/x-raw, width=1280, height=720" ! \
      vaapiencode_h264 rate-control=1 tune=high-compression cabac=true ! \
      matroskamux name=mux ! \
      filesink location="~/output.mkv" demux. ! \
      audioconvert ! faac bitrate=40000 ! aacparse ! mux.

## Get/Set time via date
get and set date via timestamp. 

**get:**
    date +%s

**set:**
    date +%s -s "@1384261338"

## boblight-X11
depends: subversion

### compile
    svn checkout http://boblight.googlecode.com/svn/trunk/ boblight
    ./configure --prefix=/usr --without-portaudio

### start
    boblight-X11 -o speed=42 -o value=5 

### Disable guest login on Ubuntu
*Tested on ubuntu 12.04 and ubuntu 14.04.*
edit/create /etc/lightdm/lightdm.conf:
    [SeatDefaults]
    user-session=ubuntu
    greeter-session=unity-greeter
    allow-guest=false

## Support for CEC adaptors under gentoo
to enable cec support for devices such as the
pulseeigt-cec adaptor you'll need the following:

in /etc/portage/make.conf:

    USE="cec"

add the user to uucp:

    gpasswd -a <username> uucp

enable in kernel CDC-ACM devices:

    kernel: USB Modem (CDC ACM) support (CONFIG_USB_ACM)


## KDE enable samba for dolphin
In most cases, dolphin tries to download files from samba shares, instead of
streaming them / giving the path to the application (vlc, mplayer). 
To tell KDE to open the files directly, put the following in the applicaions dir:

    cp /usr/share/applications/mplayer.desktop /home/$USER/.local/share/applications

add the following to /home/$USER/.local/share/applications/mplayer.desktop:

    X-KDE-Protocols=http,ftp,smb

works with mplayer and vlc and maybe some others too.

## Add the same timestamp to all files
timestamp could be e.g 201403270000

    find . | xargs touch -h -t $timestamp

## Resize DD-Image to max-size

    bzcat image-file.img > /dev/mmcblk0
    sync

eject sdcard, insert sdcard to make sure every partition gets reloaded
    fdisk /dev/mmcblk0
    p
    d
    2
    n
    p
    2
    <return>
    <return>
    w
    q
    sync

eject sdcard, insert sdcard to make sure every partition gets reloaded

    resize2fs /dev/sdb2
    sync

## List all modules needed by lspci
this prints all modules which are known drivers for lspci detected hardware:

    LC_ALL=c lspci -mvk | grep ^Driver | awk '{print $2}' | uniq

Basic pipe-knowledge
--------------------
as the "<" looks often confusing for some people:

    vim - < filename
    
the same as:

    cat filename | vim -

## sed basics
### replace

    sed 's/alt/neu/g' filename > changed_file
    sed -i 's/alt/neu/g' filename

### delete

    sed -i '/this will be deleted/d' filename

## Disable kernel sysrq calls in userland

    sysctl -w kernel.sysrq = 0

## Toggle window manager decorations
A simple python2 script to toggle window decorations in windowmanagers like marco/metacity:

    #!/usr/bin/python
    from gtk.gdk import *
   
    w=window_foreign_new((get_default_root_window().property_get("_NET_ACTIVE_WINDOW")[2][0]))
    state = w.property_get("_NET_WM_STATE")[2]
    maximized='_NET_WM_STATE_MAXIMIZED_HORZ' in state and '_NET_WM_STATE_MAXIMIZED_VERT' in state
   
    if w.get_decorations() != 0 :
        w.set_decorations(0)
    else:
        w.set_decorations(DECOR_ALL)
    window_process_all_updates()

## Xdefaults
colored manpages:
    *colorIT:      #BEC040
    *colorBD:      #728CA6
    *colorUL:      #73C040

## show xrdb colors
Display colors of xrdb compliant terminals like urxvt and xterm

    #!/bin/bash
    xrdb -l ~/.Xdefaults
    colors=($(xrdb -query | sed -n 's/.*color\([0-9]\)/\1/p' | sort -nu | cut -f2))
    for i in {0..7}; do echo -en "\e[0m \e[$((30+$i))m \xE2\x96\x88\xE2\x96\x88 ${colors[i]} \e[0m"; done
    echo
    for i in {8..15}; do echo -en "\e[0m \e[1;$((22+$i))m \xE2\x96\x88\xE2\x96\x88 ${colors[i]} \e[0m"; done
    echo

## Screen

    shelltitle "$ |terminal"
    msgwait 2
    vbell off

    altscreen on
    term screen-256color
  
    bindkey "^[Od" prev  # change window with ctrl-left
    bindkey "^[Oc" next  # change window with ctrl-right

    hardstatus alwayslastline "%{= w}%-w%{= bw} %n %t %{-}%+w %-=%{b}%c:%s"
 
## Archlinux AUR bash/zsh function

dependency: wget
add the following to ~/.bashrc or ~/.zshrc:

    function aur {
      if [ "$1" = "-Ss" ]; then
        wget "https://aur.archlinux.org/packages/?O=0&K=$2&PP=250" -O /tmp/parse.html &> /dev/null
        grep "\/packages\/" /tmp/parse.html | grep -v "?K=" | cut -d \> -f 3 | cut -d \< -f 1 | grep "$2" --color=always
        rm /tmp/parse.html
      elif [ "$1" = "-S" ]; then
        mkdir ~/aur &> /dev/null || true
        cd ~/aur
        wget https://aur.archlinux.org/cgit/aur.git/snapshot/$2.tar.gz -N &> $2.tar.gz.log
        tar -xzf $2.tar.gz
        cd $2
        makepkg -si 
      fi
    }

## ALX Network Driver

On some distributions the ALX network driver of my Dell XPS One 27 PC wont work.
This will install the correct driver:

    wget https://www.kernel.org/pub/linux/kernel/projects/backports/2013/03/04/compat-drivers-2013-03-04-u.tar.bz2 
    ./scripts/driver-select alx
    make
    su -c make install

## top 10 commands

    history | awk '{CMD[$2]++;count++;}END { for (a in CMD)print CMD[a] " " CMD[a]/count*100 "% " a;}' | grep -v "./" | column -c3 -s " " -t | sort -nr | nl | head -n10
  
## KDE Kmix Tray Scroll Step
in [Globals] in ~/.kde4/share/config/kmixrc:

    VolumePercentageStep=2
  
## MP3 remove silence
depends on package: sox
Remove silence on the beginning and the end of MP3 files:

    #!/bin/bash
    echo `date` > /tmp/trimp3.log
    for i in *.mp3; do
	    echo -n "removing silence from: $i"
	    sox "$i" "$i".tmp.mp3 silence 1 0.1 0.1% reverse silence 1 0.1 0.1% reverse &>> /tmp/trimp3.log
	    mv "$i".tmp.mp3 "$i"
	    echo "  ... done"
    done

## Xorg Display Resolution Scaling
this will fake a FullHD resolution for a display with only 1600x900:

    xrandr --output LVDS1 --mode 1600x900 --scale 1.2x1.2

## Boost mdadm raid resync
### Read-Ahead
set read-ahead to 4096:

    blockdev --setra 4096 /dev/md127

### Stripe Cache
set stripe cache to 8192

    echo 8192 > /sys/block/md127/md/stripe_cache_size

## Restore corrupted btrfs pacman files
On my notebook i got alot of corrupted files after powerloss.
I was on a upgrade (pacman -Syu) when the system shut off without syncing.
The result where alot of files (all new pacman installed files) with size "0".
btrfs check hasn't found any corruption and pacman thought everything is installed correctely.

This is how i solved it:

    pacman -S pkgfile
    pkgfile --update
    pacman -S --force $(for i in $(find /usr -size 0 -type f; do pkgfile $i; done | sort | uniq)

## usb issues on some arm devices
On some arm devices (pandaboard, odroid-x) i noticed some issues, with usb initialisation of my sat receiver. 
Adding this to the cmdline solved the problem:

    vram=16M coherent_pool=6M

# udev rule for static serial interfaces
the output of this script must be copied to: /etc/udev/rules.d/<new_rule>.rules

    echo "=== enter your data ==="; \
    echo -n "tty (e.g: /dev/ttyUSB0): "; \
    read tty; \
    echo -n "name (e.g: beagle): "; \
    read name; \
    echo "=== copy the following rule to /etc/udev/rules.d/serial.rules ==="; \
    idVendor=$(udevadm info -a -n $tty | grep '{idVendor}' | head -n1 | cut -d \" -f 2); \
    idProduct=$(udevadm info -a -n $tty | grep '{idProduct}' | head -n1 | cut -d \" -f 2); \
    idSerial=$(udevadm info -a -n $tty | grep '{serial}' | head -n1 | cut -d \" -f 2); \
    echo "SUBSYSTEM==\"tty\", ATTRS{idVendor}==\"$idVendor\", ATTRS{idProduct}==\"$idProduct\", ATTRS{serial}==\"$idSerial\", SYMLINK+=\"serial_$name\""
