#!/bin/bash

if [[ ($PROXY_USER = none) && ($PROXY_PASS = none) ]]; then
    sed -i "s/#Upstream http some.remote.proxy:port/Upstream http $PROXY_HOST:$PROXY_PORT/" /usr/local/etc/tinyproxy/tinyproxy.conf
else
    sed -i "s/#Upstream http some.remote.proxy:port/Upstream http $PROXY_USER:$PROXY_PASS@$PROXY_HOST:$PROXY_PORT/" /usr/local/etc/tinyproxy/tinyproxy.conf
fi

sed -i 's/Allow 127.0.0.1/#Allow 127.0.0.1/g' /usr/local/etc/tinyproxy/tinyproxy.conf &&\
sed -i 's/Allow ::1/#Allow ::1/g' /usr/local/etc/tinyproxy/tinyproxy.conf &&\
/usr/local/bin/tinyproxy &&\
/usr/local/bin/vpn
