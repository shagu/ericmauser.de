# Simple Wireless Router
In this article I'll describe, how to manually setup a simple wireless router.
It will use eth0 as WAN and Wlan as your private network. I was using the pandaboard for this project with gentoo linux as the distribution.

## Setup of the Wireless Accesspoint
We need hostapd to create a reliable WPA2 secured Accesspoint.

    emerge -av hostapd

Here is my current /etc/hostapd/hostapd.conf:

    interface=wlan0
    driver=nl80211
    ssid=YOUR_ESSID_GOES_HERE
    channel=YOUR_CHANNEL
    ignore_broadcast_ssid=0
    country_code=DE
    ieee80211d=1
    hw_mode=g
    ieee80211n=1
    beacon_int=100
    dtim_period=2
    macaddr_acl=0
    max_num_sta=255
    rts_threshold=2347
    fragm_threshold=2346
    logger_syslog=-1
    logger_syslog_level=2
    logger_stdout=-1
    logger_stdout_level=2
    dump_file=/tmp/hostapd.dump
    ctrl_interface=/var/run/hostapd
    ctrl_interface_group=0
    auth_algs=3
    wmm_enabled=1
    wpa=2
    rsn_preauth=1
    rsn_preauth_interfaces=wlan0
    wpa_key_mgmt=WPA-PSK
    rsn_pairwise=CCMP
    wpa_group_rekey=600
    wpa_ptk_rekey=600
    wpa_gmk_rekey=86400
    wpa_passphrase=YOURPASSWORD

## DHCP

This is a N-Wlan-Only Config. Now the WLAN Accesspoint should be set up.
Due usability, you may want a DHCP server, in that case, i've installed
dnsmasq:

    emerge -av dnsmasq

This is my dnsmasq config:

    # DHCP-Server aktiv für Interface
    interface=wlan0

    # DHCP-Server nicht aktiv für Interface
    no-dhcp-interface=eth0

    # IP-Adressbereich / Lease-Time
    dhcp-range=interface:wlan0,10.4.4.2,10.4.4.200,infinite

    # static ips
    #dhcp-host=<MAC-Adresse>,<Name>,<IP-Adresse>,infinite
    #dhcp-host=f1:f1:f1:f1:f1:f1,,10.4.4.2,infinite

## Routing

In order to NAT the eth0 through wlan, do the following with iptables:

    iptables -F
    iptables -t nat -F
    iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

    sysctl -w net.ipv4.ip_forward=1
    sysctl -p
