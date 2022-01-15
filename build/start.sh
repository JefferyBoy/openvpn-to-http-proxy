#!/bin/bash
# Start squid service
start_squid()
{
    service squid start
    if [ ! `service squid status | grep "squid is running" | wc -l` -gt 0 ]; then 
        echo "Error: failed to start squid service" >&2; 
        return 1
    fi
    return 0
}

# openvpn authentication file
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

# start squid service. retry 3
for i in `seq 3`
do
    start_squid
    if [ $? -eq 0 ]; then
        break 
    fi
    if [ $i -eq 3 ]; then
        echo "Error: failed to start squid service." >&2
        exit 1
    fi
done
service squid status

# make net required file
if [ ! -e /dev/net/tun ]; then
    mkdir /dev/net -pv
    mknod /dev/net/tun c 10 200
    chmod 666 /dev/net/tun
fi
# start openvpn
openvpn --config $ovpn --auth-user-pass $auth_file
