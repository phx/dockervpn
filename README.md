# DockerVPN

DockerVPN is an OpenConnect-based VPN client that exposes an upstream proxy via TinyProxy on localhost:8888. DockerVPN uses the docker0 interface so you can stay connected to both an external network, while having SSH and HTTP/S access to a remote internal network, and it's a great alternative to VPN split-tunneling. 

## Install:
1. `git clone https://github.com/phx/dockervpn.git`
2. `cd dockervpn`
3. `./install.sh`

## Run:
```
Connect:                'dockervpn'
Re-connect:             'dockervpn'
Disconnect:             'docker stop dockervpn'
View status/logs:       'docker logs dockervpn'
Exec into container:    'sshvpn'

Browse to internal sites: point proxy to '127.0.0.1:8888'

To change (and persist) VPN and/or proxy passwords:
'dockervpn --changepass' OR
'dockervpn --changepass [OLD_VPN/PROXY_PASS] [NEW_VPN/PROXY_PASS]' OR
'dockervpn --changepass [OLD_VPN_PASS] [NEW_VPN_PASS] [OLD_PROXY_PASS] [NEW_PROXY_PASS]'

-c | --creds [USER:PASS]                Specify credentials to use for both VPN_USER/PROXY_USER and VPN_PASS/PROXY_PASS

-h | --help                             Display this help text.

-i | --interactive                      Run in interactive mode and prompt for VPN_USER, VPN_PASS, PROXY_USER, and PROXY_PASS.
                                        If you wish to do this, you can remove any hardcoded variables from /usr/local/bin/dockervpn.

-p | --password [VPN_PASS/PROXY_PASS]   Pass the VPN_PASS/PROXY_PASS password on the command line (both passwords must match to use this option.

-u | --user  [VPN_USER/PROXY_USER]      Specify the user. You will be prompted for password if not combined with -p or --password.

-e | --endpoint                         Specify an alternate VPN_ENDPOINT to connect to. You will be prompted for credentials.
```
## Uninstall:
1. `git clone https://github.com/phx/dockervpn.git` (in case you already deleted it)
2. `cd dockervpn`
3. `./uninstall.sh`

## To-Do:
- Debug all of the command line parameters
- Maybe re-do `install.sh` using `case` statements to provide better functionality for more use cases
