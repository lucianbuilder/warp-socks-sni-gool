#!/bin/sh

# exit when any command fails
set -e

# create a tun device if not exist to ensure compatibility with Podman
#if [ ! -e /dev/net/tun ]; then
#    sudo mkdir -p /dev/net
#    sudo mknod /dev/net/tun c 10 200
#    sudo chmod 600 /dev/net/tun
#fi

# start dbus
#sudo mkdir -p /run/dbus
#if [ -f /run/dbus/pid ]; then
#    sudo rm /run/dbus/pid
#fi
#sudo dbus-daemon --config-file=/usr/share/dbus-1/system.conf

# start the daemon
#sudo warp-svc --accept-tos &

# sleep to wait for the daemon to start, default 2 seconds
#sleep "$WARP_SLEEP"
#sleep 30s

# if /var/lib/cloudflare-warp/reg.json not exists, setup new warp client
#if [ ! -f /var/lib/cloudflare-warp/reg.json ]; then
#    # if /var/lib/cloudflare-warp/mdm.xml not exists or REGISTER_WHEN_MDM_EXISTS not empty, register the warp client
#    if [ ! -f /var/lib/cloudflare-warp/mdm.xml ] || [ -n "$REGISTER_WHEN_MDM_EXISTS" ]; then
#        sudo warp-cli --accept-tos registration new && echo "Warp client registered!"
        # if a license key is provided, register the license
#        if [ -n "$WARP_LICENSE_KEY" ]; then
#            echo "License key found, registering license..."
#            sudo warp-cli --accept-tos registration license "$WARP_LICENSE_KEY" && echo "Warp license registered!"
#        fi
#    sudo warp-cli --accept-tos tunnel protocol set MASQUE
#    sudo warp-cli --accept-tos mode proxy
#    fi
    # connect to the warp server
#    sudo warp-cli --accept-tos connect
#else
#    echo "Warp client already registered, skip registration"
#fi

# start the proxy
#echo "Run sniproxy ..." && \
#./sniproxy \
#    --forward-proxy="socks5://localhost:40000" \
#    --dns-upstream=1.1.1.1 \
#    --dns-redirect-ipv4-to=127.0.0.1 \
#    --verbose
echo "Run sniproxy ..." && \
	nohup ./warp-plus -v --gool & 
	proxychains4 sniproxy -c /etc/sniproxy.conf -f
#	sniproxy -c /etc/sniproxytest.conf -f
