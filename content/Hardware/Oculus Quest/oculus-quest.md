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
The tool "SideQuest" provides an own launcher that can be found in the "Apps" section, simply called: "SideQuest Launcher".

As an alternative, you can check out the unity based launcher named [QuestAppLauncher](https://github.com/tverona1/QuestAppLauncher).
The release page provides APKs, that can be simply installed via ADB, without the need of SideQuest or any other tools.

## Custom Beatsaber Songs
In order to make use of user made songs, you will need to install [BMPF](https://github.com/kihecido/BMBF) which basically uninstalls Beatsaber, extracts the APK, patches it and bundles it up again.

Visit their [GitHub Release Page](https://github.com/kihecido/BMBF/releases/tag/v1.4.5) and grab the latest APKs. I downloaded both and installed them via ADB:

    adb install BMBF_TVWrapper.1.apk
    adb install com.weloveoculus.BMBF.apk

Once both are installed, launch the BMPF App. This will guide you through the installation process and at the end, do not launch Beat Saber directly. Instead click on the 3 dots (...) on the BeatSaber App in the library, and enable the storage permissions. You can now run Beatsaber as usual, or if you want to add new tacks, just launch the BMPF. This will allow you transfer songs to the device via an open port. The IP address and the port of it, can be found in the "Tools" tab of BMPF. Open it in your browser and drag the songs you like into it. A good source for user made custom songs is: [Beast Saber](https://bsaber.com/).

## Termux
To install and use termux, you will need to fetch the APK from any mirror site like [Apkpure](https://apkpure.com/termux/com.termux), [APKMirror](https://www.apkmirror.com/apk/fredrik-fornwall/termux/) or directly from [F-Droid](https://f-droid.org/en/packages/com.termux/). Install the APK onto the device by typing: `adb install com.termux_84.apk`. Since the app was not specifically made for the oculus, it won't show up in the app-menu. But, the oculus has an "Oculus TV" app for those apps, that aren't VR-Ready, go there, select "Channels" and open the Termux app.

## Stream to Display
Streaming can only be achieved via an official chromecast device, the Nvidia SHIELD or the official Oculus mobile app.

## Wireless ADB
Android allows us to remotly debug the device over the wireless network. First you will need to plug in the cable and start a regular shell session, in order to obtain the IP Address and to enable the tcpip debugging of adb.

    adb shell ip route
    10.23.0.0/24 dev wlan0  proto kernel  scope link  src 10.23.0.247
                                                            ^- device IP

    adb tcpip 5555
    adb connect 10.23.0.247:5555

 You're now connected to the remote device via network and send any adb commands you like. To stop the session, type:

    adb disconnect

## Stream to Desktop
It is possible to stream the raw display of the oculus quest to your PC, by using builtin android tools and `ffmpeg` on your Desktop. Android has an executable called `screenrecord`, which is capable of recording the entire screen to the stdout. This allows us to pipe it through `adb` to our PC, where ffmpeg receives the stream and displays it. This even works on the restricted content like TV and 2D apps.

    adb exec-out "while true; do screenrecord --bit-rate=4m --size 1280x720 --time-limit=60 --output-format=h264 -; done" | ffplay -framerate 300 -probesize 32 -sync video -

In the command above, I set the framerate incredible high on purpose. This is to make sure that none of the buffers on the `ffplay`-side will fill up and start causing a lag, that is getting worse and worse. Having such a high framerate combined with the low probe size and the sync option, will cause ffplay to instantly play every received frame and ignoring everyhting else it didn't get.
Here's alot more room for improvements, but for now, this one gave me the best results.
