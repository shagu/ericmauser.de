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

    fastboot flashall -w
    
Lock bootloader again:

    fastboot flashing lock
