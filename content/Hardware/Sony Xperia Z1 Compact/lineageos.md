# Build LineageOS for Xperia Z1 Compact
Build instructions to compile LineageOS from scratch, using a reproducable lxc container setup. This guide is dedicated for the Xperia Z1 Compact device, which is also known as `amami` or `d5503`. It will use `ubuntu` as an LXC container, so your host system does not matter as long as it has `lxc` installed properly. Ubuntu is the choice here, because it's the preferred distribution in the Sony Xperia AOSP build instructions and also in the official AOSP documentation.

## Setup LXC container
Create an LXC container with ubuntu installed. If xenial is not used by default, pass `-- -r xenial` to the `lxc-create` command.

    lxc-create -n lineage -t ubuntu

Change container config to use the host network

    sed -i "s/lxc.network.type = empty/lxc.network.type = none/g" /var/lib/lxc/lineage/config

Start and attach the new session

    lxc-start  -n lineage
    lxc-attach -n lineage

If the container does not receive any default nameserver, add a default nameserver on every login and re-attach the container.

    echo 'echo "nameserver 8.8.8.8" > /etc/resolv.conf' >> /root/.bashrc && exit
    lxc-attach -n lineage

## Setup Ubuntu
Update all packages and install the required build dependencies.

    apt-get update && apt-get upgrade
    apt-get install bc bison bsdmainutils build-essential curl flex gcc-multilib \
        git g++-multilib gnupg gperf imagemagick lib32ncurses5-dev lib32readline6-dev \
        lib32z1-dev libesd0-dev liblz4-tool libncurses5-dev libsdl1.2-dev libssl-dev \
        libwxgtk3.0-dev libxml2 libxml2-utils lzop make openjdk-8-jdk pngcrush repo \
        rsync schedtool squashfs-tools xsltproc zip zlib1g-dev

## Setup the Build Environment
Add a build user and initialize all git repositories.

    adduser build
    su -l build

    git config --global user.email "build@lineage"
    git config --global user.name "Build User"

    repo init -u https://github.com/LineageOS/android.git -b cm-14.1

Copy [los_amami.xml](los_amami.xml) into the `local_manifests` directory to add support for amami (Xperia Z1 Compact) devices.

    mkdir .repo/local_manifests
    mv los_amami.xml .repo/local_manifests

Grab the Sony AOSP binaries and place them in ~/ of your build user. The binaries can be found on the official sonyxperiadev website: [Download AOSP Binararies for Xperia Devices](https://developer.sonymobile.com/open-devices/list-of-devices-and-resources/)

    unzip SW_binaries_for_Xperia_AOSP_*.zip

## Download
This will download up to 50GB of source code. Have a break ;)

    repo sync

In case you already messed something up, you might want to use the forced mode instead.

    repo sync --force-sync

## Compile
Replace `-j4` with the number of the CPU Cores you have and `12G` with the amount of RAM you would like to use during the build. Set `-M 50G` to the amount of storage that ccache is allowed to use.

    export USE_CCACHE=1
    export ANDROID_JACK_VM_ARGS="-Dfile.encoding=UTF-8 -XX:+TieredCompilation -Xmx12G"
    prebuilts/misc/linux-x86/ccache/ccache -M 50G

    . build/envsetup.sh
    lunch lineage_amami-userdebug
    make bacon -j4

## Troubleshooting
If you encounter any `ninja_wrapper` errors, disable ninja and try to build again.

    export USE_NINJA=false
