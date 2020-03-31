# GL.iNet GL-MT300N-V2

## About

    Chipset:     MediaTek MT7628NN
    RAM:         128MB DDR1
    Flash:       16 MB
    Connections: 2x Ethernet, 1x 2.4Ghz WiFI (bgn), 1x USB 2.0
    LEDs:        3

Website: https://www.gl-inet.com/products/gl-mt300n-v2/
OpenWRT: https://openwrt.org/toh/gl.inet/gl.inet_gl-mt300n_v2

## Stock Settings

    ssid: GL-MT300N-V2-{SOMETHING}
    pw:   goodlife
    ip:   192.168.8.1

## Debricking

Device comes with a pre-installed u-boot web interface on `192.168.1.1`. Press and hold the reset button when powering on the device, hold for at least 3 seconds.

## Factory Reset
Press and hold reset button for **10 seconds**, and then release to reset the router to factory settings. All user data will be cleared.

## OpenWRT
wiki: https://openwrt.org/toh/gl.inet/gl.inet_gl-mt300n_v2

    $ git clone https://git.openwrt.org/openwrt/openwrt.git
    $ make menuconfig
    Target System -> MediaTek Ralink MIPS
    Subtarget -> MT76x8 based boards
    Target Profile -> GL.iNet GL-MT300N V2
    $ make -j4
