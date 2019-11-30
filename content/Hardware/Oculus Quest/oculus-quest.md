# Oculus Quest 128G

## About
The Oculus Quest is a standalone, android-based VR Headset created by Oculus VR (Facebook). The battery lasts around 2-4 hours, depending on the load.

    Linux Kernel: 4.4.21
    Storage:      128 GB
    Memory:       4 GB
    CPU:          4 Kryo 280 Gold (ARM Cortex-A73 based) @ 2.45 GHz
                  4 Kryo 280 Silver (ARM Cortex-A73 based) @ 1.9 GHz

    GPU:          Adreno 540

    CPU-Info:     4x Processor	: AArch64 Processor rev 4 (aarch64)
                  BogoMIPS	: 38.40
                  Features	: fp asimd evtstrm aes pmull sha1 sha2 crc32
                  CPU implementer	: 0x51
                  CPU architecture: 8
                  CPU variant	: 0xa
                  CPU part	: 0x801
                  CPU revision	: 4

                  Hardware	: Qualcomm Technologies, Inc APQ8998

## Developer Mode
Since the device is android based, you can load any APK onto the device. First you need to sign up for a "developer account".
You can type in anything you want here, there won't be any further checks.
Visit: [Oculus Dashboard](https://dashboard.oculus.com/organizations/create/)

Once you created an "organization", you will be able to enable the development mode via the paired mobile app.

Plug in the Oculus Device into the PC and launch "adb shell". Within the headset, a popup will show up, asking you to confirm the connection.
Voila, your headset is paired and you can use `adb shell` to browse the device or `adb install` to install any app you like.

Most non-VR-ready apps won't show up in the regular place, you will either need to get a special launcher or launch them via the "Oculus TV" app.

## Termux
To install and use termux, you will need to fetch the APK from any mirror site like [Apkpure](https://apkpure.com/termux/com.termux), [APKMirror](https://www.apkmirror.com/apk/fredrik-fornwall/termux/) or directly from [F-Droid](https://f-droid.org/en/packages/com.termux/). Install the APK onto the device by typing: `adb install com.termux_84.apk`. Since the app was not specifically made for the oculus, it won't show up in the app-menu. But, the oculus has an "Oculus TV" app for those apps, that aren't VR-Ready, go there, select "Channels" and open the Termux app.

## Stream to Display
Streaming can only be achieved via an official chromecast device, the Nvidia SHIELD or the official Oculus mobile app.
