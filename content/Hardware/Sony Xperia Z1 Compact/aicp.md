# Build AICP for Xperia Z1 Compact
Build instructions to compile AICP from scratch, using a reproducable lxc container setup. This guide is dedicated for the Xperia Z1 Compact device, which is also known as `amami` or `d5503`. It will use `ubuntu` as an LXC container, so your host system does not matter as long as it has `lxc` installed properly. Ubuntu is the choice here, because it's the preferred distribution in the Sony Xperia AOSP build instructions and also in the official AOSP documentation.

## Setup LXC container
Create an LXC container with ubuntu installed. If xenial is not used by default, pass `-- -r xenial` to the `lxc-create` command.

    lxc-create -n aicp -t ubuntu

Change container config to use the host network

    sed -i "s/lxc.network.type = empty/lxc.network.type = none/g" /var/lib/lxc/aicp/config

Start and attach the new session

    lxc-start  -n aicp
    lxc-attach -n aicp

If the container does not receive any default nameserver, add a default nameserver on every login and re-attach the container.

    echo 'echo "nameserver 8.8.8.8" > /etc/resolv.conf' >> /root/.bashrc && exit
    lxc-attach -n aicp

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

    git config --global user.email "build@aicp"
    git config --global user.name "Build User"

    repo init -u https://github.com/AICP/platform_manifest.git -b n7.1

## Download

    repo sync

## Compile

    . build/envsetup.sh
    brunch
