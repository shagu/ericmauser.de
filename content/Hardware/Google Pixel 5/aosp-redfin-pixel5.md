# Google Pixel 5 (redfin)

## AOSP Build (Ubuntu 18.04)

### Setup LXC Build Container

    lxc-create aosp -t download -- -d ubuntu -r bionic -a amd64
    sed -i "s/lxc.net.0.type = empty/lxc.net.0.type = none/g" /var/lib/lxc/aosp/config

    lxc-start aosp
    lxc-attach aosp

    echo 'echo "nameserver 8.8.8.8" > /etc/resolv.conf' >> /root/.bashrc && exit
    lxc-attach aosp

### Install Dependencies

    sudo apt-get update
    sudo apt-get install rsync git-core gnupg flex bison build-essential zip curl zlib1g-dev gcc-multilib g++-multilib libncurses5 libc6-dev-i386 lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z1-dev libgl1-mesa-dev libxml2-utils xsltproc unzip fontconfig python2.7 repo android-sdk-platform-tools-common vim
    sudo gpasswd -a ubuntu plugdev

### Prepare User

    git config --global user.name "Bob Builder"
    git config --global user.email "build@example.org"

### Fetch sources

Check google's build numbers to identify the best tag for pixel 5: [Codenames, Tags, and Build Numbers](https://source.android.com/setup/start/build-numbers)

    mkdir aosp; cd aosp
    repo init -u https://android.googlesource.com/platform/manifest -b android-11.0.0_r7
    repo sync -q -c -j8

### Get the Binaries

The latest version of the binaries can be found on the [Driver Binaries](https://developers.google.com/android/drivers) page.

    curl https://dl.google.com/dl/android/aosp/google_devices-redfin-rd1a.200810.020-3940ace1.tgz | tar xvz
    ./extract-google_devices-redfin.sh

    curl https://dl.google.com/dl/android/aosp/qcom-redfin-rd1a.200810.020-e99cf7f8.tgz | tar xvz
    ./extract-qcom-redfin.sh

    git clone https://github.com/shagu/pixelmod/ vendor/pixelmod


### Configure Environment

    source build/envsetup.sh
    vendor/pixelmod/redfin/enable.sh
    lunch aosp_redfin-userdebug

### Build

    m dist
    m fastboot adb

### Flash

Stock ROM: [Download Page](https://developers.google.com/android/images) ([Direct Download](https://dl.google.com/dl/android/aosp/redfin-rd1a.200810.020-factory-c3ea1715.zip))

To enable OEM unlocking on the device:
  - In Settings, tap About phone, then tap Build number seven times.
  - When you see the message You are a developer, tap the back button.
  - Tap Developer options and enable OEM unlocking and USB debugging.

Turn off the phone, press and hold Volume Down, then press and hold Power.

    fastboot flashing unlock

Flash all images:

    export ANDROID_PRODUCT_OUT=/home/lxc/aosp/rootfs/home/ubuntu/aosp/out/target/product/redfin
    fastboot flashall -w --skip-reboot

Lock bootloader again:

    fastboot flashing lock

## Notes/Hints

### Building on Archlinux (Unstable)

The build requires ncruses5 which is no longer in the arch repositorys. It's possible to use the prebuild library that
is shipped with the aosp sources or to install [ncurses5-compat-libs (AUR)](https://aur.archlinux.org/packages/ncurses5-compat-libs/).

    pacman -S base-devel multilib-devel gcc repo git gnupg gperf sdl wxgtk2 squashfs-tools curl ncurses zlib schedtool perl-switch zip unzip libxslt bc rsync ccache lib32-zlib lib32-ncurses lib32-readline
    cp prebuilts/gcc/linux-x86/host/x86_64-linux-glibc2.17-4.8/sysroot/usr/lib/libncurses.so.5 /lib/libncurses.so.5

### Additional Flash Commands
Flash image zip via fastboot file:

    fastboot -w update aosp_redfin-img-eng.ubuntu.zip

Flash otau update via adb/recovery:

    adb sideload aosp_redfin-ota-eng.ubuntu.zip
