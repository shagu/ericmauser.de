# Official Nvidia Optimus

this describes how to setup the original nvidia mechanisms for nvidia optimus chips on gentoo.

**add in /etc/make.conf:**
    VIDEO_CARDS="intel nvidia modesetting"

**depends:**
 
    nvidia-drivers >= 304
    xrandr >= 1.4
    xorg-server >= 1.13
    (theese are all available in gentoo stable.)

**in /etc/xorg.conf:**
    Section "ServerLayout"
        Identifier "layout"
        Screen 0 "nvidia"
        Inactive "intel"
    EndSection
  
    Section "Device"
        Identifier "nvidia"
        Driver "nvidia"
        BusID "PCI:1:0:0"
    EndSection
  
    Section "Screen"
        Identifier "nvidia"
        Device "nvidia"
        Option "UseDisplayDevice" "none"
    EndSection
  
    Section "Device"
        Identifier "intel"
        Driver "modesetting"
    EndSection
  
    Section "Screen"
        Identifier "intel"
        Device "intel"
    EndSection

**in ~/.xinitrc:**
    xrandr --setprovideroutputsource modesetting NVIDIA-0
    xrandr --auto
