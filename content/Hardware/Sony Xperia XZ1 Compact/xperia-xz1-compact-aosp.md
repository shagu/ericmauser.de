(2020/02/02)

# Sony Xperia XZ1 Compact (lilac)
## Android Open Source Project (AOSP)
### Prepare LXC
    lxc-create -n aosp -t download
    sed -i "s/lxc.net.0.type = empty/lxc.net.0.type = none/g" /var/lib/lxc/aosp/config

    mv /var/lib/lxc/aosp /home/eric/aosp
    ln -s /home/eric/aosp /var/lib/lxc/aosp
    lxc-start  -n aosp
    lxc-attach -n aosp

    echo 'echo "nameserver 8.8.8.8" > /etc/resolv.conf' >> /root/.bashrc && exit
    lxc-attach -n aosp

### Install Dependencies
    dpkg --add-architecture i386
    apt-get update
    apt-get install openjdk-8-jdk repo
    apt-get install bison g++-multilib git gperf libxml2-utils make zlib1g-dev:i386 \
                    zip liblz4-tool libncurses5 libssl-dev bc flex rsync

### Prepare Sources
    su -l ubuntu
    export branch=android-10.0.0_r21
    git config --global user.email "build@ubuntu"
    git config --global user.name "local"

    mkdir ~/android
    cd ~/android
    repo init -u https://android.googlesource.com/platform/manifest -b $branch

    cd .repo
    git clone https://github.com/sonyxperiadev/local_manifests
    cd local_manifests
    git checkout $branch
    cd ../..
    repo sync
    ./repo_update.sh

## Rebuild Kernel (optional)
Currently required, due to [[Yoshino][Lilac] Kernel 4.14 bootloops.](https://github.com/sonyxperiadev/bug_tracker/issues/530):
    rm -rf kernel/sony/msm-4.14/common-kernel/
    cd kernel/sony/msm-4.14/kernel/
    git checkout b5b8742^
    cd -

## Build
    source build/envsetup.sh && lunch
    make -j$(nproc)

## Flash
    fastboot flash oem SW_binaries_for_Xperia_Android_10*.img

    fastboot flash boot boot.img
    fastboot flash recovery recovery.img
    fastboot flash system system.img
    fastboot flash vendor vendor.img
    fastboot flash userdata userdata.img
