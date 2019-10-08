#!/bin/bash

PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin

user="${VPN_USER}"
pass="${VPN_PASS}"
key="${SECRET_KEY}"
endpoint=[VPN_ENDPOINT]
t=$(oathtool --totp -b "$key")

echo "${pass}${t}" | openconnect "${endpoint}" -m 1290 -u "${user}"
