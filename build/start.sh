#!/bin/bash
auth_file=/etc/openvpn/client/auth-user-pass
if [ -z $ovpn ]; then
    echo "Please config the openvpn config file path(eg: ovpn=/file/path/xxx.ovpn)" >&2
    exit 1
fi
if [ ! -f "$ovpn" ]; then
    echo "The openvpn confiuration file not exist: $ovpn" >&2
    exit 1
fi
echo "$username" > $auth_file
echo "$password" >> $auth_file

service squid start
if [ 0 -eq $? ]; then
    if [ ! -e /dev/net/tun ]; then
        mkdir /dev/net -pv
        mknod /dev/net/tun c 10 200
        chmod 666 /dev/net/tun
    fi
    openvpn --config $ovpn --auth-user-pass $auth_file
fi