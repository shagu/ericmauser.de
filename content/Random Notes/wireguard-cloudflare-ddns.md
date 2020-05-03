# Wireguard with Cloudflare DDNS from Android to OpenWRT
## OpenWRT Setup

    opkg update
    opkg install luci-ssl
    reboot

### Cloudflare DDNS
#### SSH

    opkg update
    opkg install ddns-scripts_cloudflare.com-v4
    opkg install ca-certificates
    opkg install luci-app-ddns

#### LUCI
Go to Services -> Dynamic DNS

    Name: $SUBDOMAIN
    Click: Add
    DDNS Service Provider: cloudflare.com-v4
    Domain: $SUBDOMAIN@$DOMAIN.$TLD
    Username: $CLOUDFLARE_MAIL
    Password: $GLOBAL_APIKEY
    Use HTTP Secure: [x]
    Path to CA-Certificate: /etc/ssl/certs

    Click: Advanced Settings

    IP address source [IPv4]: URL
    URL to detect [IPv4]: http://checkip.dyndns.com

    Click: Save & Apply

### Wireguard
#### Generate Keys

    wg genkey | tee privkey | wg pubkey > pubkey

#### SSH

    opkg install luci-app-wireguard
    reboot

#### LUCI
Go to: Network -> Firewall -> Port Forwards

    Name: WireGuard
    Protocol: UDP
    External Zone: WAN
    External Port: 4040
    Internal Zone: LAN
    Internal IP Address: 10.4.4.1
    Internal Port: 4040

Go to: Network -> Firewall -> Traffic Rules

    Open ports on router
    Name: WireGuard
    Protocol: UDP
    External Port: 4040

Network -> Interfaces -> Add new interface

    Name: wg0
    Protocol: WireGuard VPN
    Private Key: $ROUTER_PRIVATE
    Firewall Settings: LAN
    Listen Port: 4040
    IP Addresses: 10.10.0.0/16

    Click: Add Peer

    Public Key: $MOBILE_PUBLIC
    Allowed IPs: 10.10.0.5/32
    Route Allowed IPs: [x]
    Persistent Keep Alive: 25

System -> Reboot

## Provider Modem: O2 Connect Box
Heimnetzwerk -> Port Forwarding

    Port Forwarding aktivieren: [x]
    Click: Regel Hinzufügen

    Computer: 192.168.1.2
    1. Portbereich: 4040 - 4040
    Protokoll: UDP
    Click: Speichern

## Android Phone
Install and open the Wireguard App. Click "(+)" and select "Create from scratch".

    Name: $WIREGUARD_NAME
    Private Key: $MOBILE_PRIVATE
    Addresses: 10.10.0.5/32
    DNS Servers: 10.4.4.1

    Click: Add Peer

    Public Key: $ROUTER_PUBLIC
    Allowed IPs: 0.0.0.0/0,::0

    Endpoint: $PUBLIC_IP/$PORT
    Persistent Keep Alive: 25
