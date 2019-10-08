#!/bin/bash

echo -e '\nUninstalling DockerVPN...'
sudo rm -vf /usr/local/bin/dockervpn
sudo rm -vf /usr/local/bin/sshvpn
echo -e '\nStopping any running DockerVPN cantainer...'
sudo docker stop vpn 2>/dev/null
echo -e '\nRemoving any stopped DockerVPN containers...'
sudo docker rm vpn 2>/dev/null
echo -e '\nRemoving the DockerVPN image...'
sudo docker rmi vpn 2>/dev/null
echo -e '\nDone.\n'

