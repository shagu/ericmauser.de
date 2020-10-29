# Google Pixel 5 (redfin)

## AOSP Build (Ubuntu 18.04)

### Install Dependencies

    sudo apt-get update
    sudo apt-get install rsync git-core gnupg flex bison build-essential zip curl zlib1g-dev gcc-multilib g++-multilib libncurses5 libc6-dev-i386 lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z1-dev libgl1-mesa-dev libxml2-utils xsltproc unzip fontconfig python2.7 repo android-sdk-platform-tools-common vim
    sudo gpasswd -a bob plugdev

### Prepare User

    git config --global user.name "Bob Builder"
    git config --global user.email "build@example.org"

### fetch sources

Check google's build numbers to identify the best tag for pixel 5: [Codenames, Tags, and Build Numbers](https://source.android.com/setup/start/build-numbers)

    mkdir aosp
    cd aosp
    repo init -u https://android.googlesource.com/platform/manifest -b android-11.0.0_r7
    repo sync -q -c -j8

### Configure Environment

    source build/envsetup.sh
    lunch

### Get the Binaries

The latest version of the binaries can be found on the [Driver Binaries](https://developers.google.com/android/drivers) page.

    curl -o google.tgz https://dl.google.com/dl/android/aosp/google_devices-redfin-rd1a.200810.020-3940ace1.tgz
    curl -o qualcomm.tgz https://dl.google.com/dl/android/aosp/qcom-redfin-rd1a.200810.020-e99cf7f8.tgz

    tar xf google.tgz
    tar xf qualcomm.tgz

    ./extract-google_devices-redfin.sh
    ./extract-qcom-redfin.sh

### Build

    m dist
    m fastboot adb

### Flash

Stock ROM: [Download Page](https://developers.google.com/android/images) [Direct Download](https://dl.google.com/dl/android/aosp/redfin-rd1a.200810.020-factory-c3ea1715.zip)

To enable OEM unlocking on the device:
  - In Settings, tap About phone, then tap Build number seven times.
  - When you see the message You are a developer, tap the back button.
  - Tap Developer options and enable OEM unlocking and USB debugging.

Turn off the phone, press and hold Volume Down, then press and hold Power.

    fastboot flashing unlock

Flash all images:

    fastboot flashall -w --skip-reboot

Lock bootloader again:

    fastboot flashing lock

## Notes/Hints

The AOSP build procedure depends heavily on the host utils such as `mkfs` and the linux kernel.
Not using ubuntu 18.04 might result in an image that won't boot due to ext4 features that did exist in the host, but don't exist in android.
It's highly recommended to use ubuntu 18.04, otherwise many parts of the build need to be patched. Just be aware, you might end up including
ext4 features that aosp does not support yet.

`no valid slot to boot`:

    Unable to enable ext4 casefold on /dev/block/by-name/metadata because /system/bin/tune2fs is missing
    E:Open failed: /metadata/ota: No such file or directory
    E: Couldn't mount Metadata.
    W:DM_DEV_STATUS failed for system_a: No such device or address

### Setup LXC Build Container (Unstable)

    lxc-create aosp -t download -- -d ubuntu -r bionic -a amd64
    sed -i "s/lxc.net.0.type = empty/lxc.net.0.type = none/g" /var/lib/lxc/aosp/config

    lxc-start aosp
    lxc-attach aosp

    echo 'echo "nameserver 8.8.8.8" > /etc/resolv.conf' >> /root/.bashrc && exit
    lxc-attach aosp

### Building on Archlinux (Unstable)

The build requires ncruses5 which is no longer in the arch repositorys. It's possible to use the prebuild library that
is shipped with the aosp sources or to install [ncurses5-compat-libs (AUR)](https://aur.archlinux.org/packages/ncurses5-compat-libs/).

    pacman -S base-devel multilib-devel gcc repo git gnupg gperf sdl wxgtk2 squashfs-tools curl ncurses zlib schedtool perl-switch zip unzip libxslt bc rsync ccache lib32-zlib lib32-ncurses lib32-readline
    cp prebuilts/gcc/linux-x86/host/x86_64-linux-glibc2.17-4.8/sysroot/usr/lib/libncurses.so.5 /lib/libncurses.so.5

### Modify Root Filesystem via ADB

    adb root
    adb remount
    adb reboot

### Modify AOSP Packages
#### Remove Certain Apps / Add Pre-Built (F-Droid)

    cd packages/apps/
    mkdir fdroid
    curl -o fdroid/fdroid.apk https://f-droid.org/F-Droid.apk
    cat > fdroid/Android.mk << 'EOF'
    LOCAL_PATH := $(call my-dir)
    include $(CLEAR_VARS)
    LOCAL_MODULE_TAGS := optional
    LOCAL_MODULE := fdroid
    LOCAL_SRC_FILES := $(LOCAL_MODULE).apk
    LOCAL_MODULE_CLASS := APPS
    LOCAL_MODULE_SUFFIX := $(COMMON_ANDROID_PACKAGE_SUFFIX)
    LOCAL_CERTIFICATE := PRESIGNED
    LOCAL_MODULE_PATH := $(TARGET_OUT_DATA)
    include $(BUILD_PREBUILT)
    EOF

    vim build/target/product/handheld_product.mk
      -> remove "Browser2", "QuickSearchBox"
      -> add "fdroid"

### Additional Flash Commands
Flash image zip via fastboot file:

    fastboot -w update aosp_redfin-img-eng.ubuntu.zip

Flash otau update via adb/recovery:

    adb sideload aosp_redfin-ota-eng.ubuntu.zip
