# Carambola

## Toolchain (vendor)

    git clone https://github.com/8devices/carambola carambola
    ./scripts/feeds update -a
    ./scripts/feeds install -a

    make kernel_menuconfig
    make menuconfig
    make

### Patching Kernel's VLAN Settings

[http://8devices.com/community/viewtopic.php?f=6&t=42](http://8devices.com/community/viewtopic.php?f=6&t=42)

in **/build_dir/linux-ramips_rt305x/linux-2.6.39.4/arch/mips/ralink/rt305x/mach-carambola.c**:

replace:

    rt305x_esw_data.vlan_config = RT305X_ESW_VLAN_CONFIG_LLLLW;

with:

    rt305x_esw_data.vlan_config = RT305X_ESW_VLAN_CONFIG_WLLLL;

result:

    => eth0: WAN Port
    => eth1: LAN Port

## Toolchain (mainline)

    git clone https://www.github.com/openwrt/openwrt
    cd openwrt
    ./scripts/feeds update -a
    ./scripts/feeds install -a
    make menuconfig

    # Target System -> MediaTek Ralink MIPS
    # Subtarget -> RT3x5x/RT5350 based boards
    # Target profile -> 8devices Carambola
    # LuCI -> Collections -> luci-ssl (*)

    make -j8

## flashing
install `atftp`

    TFTPD_ROOT="/home/eric/share"
    TFTPD_OPTS="--daemon --user nobody --group nobody"

Connect serial cable to carambola. When this message appears, press "2":

    Please choose the operation:
      1: Load system code to SDRAM via TFTP.
      2: Load system code then write to Flash via TFTP.
      3: Boot system code via Flash (default).
      4: Entr boot command line interface.
      9: Load Boot Loader code then write to Flash via TFTP.
