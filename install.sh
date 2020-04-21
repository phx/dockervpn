#!/bin/bash
##############################################################################
# Copyright (C) 2018  phx
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU Affero General Public License as published
#    by the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU Affero General Public License for more details.
#
#    You should have received a copy of the GNU Affero General Public License
#    along with this program.  If not, see <https://www.gnu.org/licenses/>.
#
##############################################################################

if ! command -v docker &>/dev/null; then
  curl -fsSL 'https://raw.githubusercontent.com/phx/dockerinstall/master/install_docker.sh' | /bin/bash
fi

# parse .env file if it exists
if [[ -f .env ]]; then
  values="$(awk -F '=' '{print $2}' .env)"
  VPN_USER="$(echo "$values" | head -1)"
  VPN_PASS="$(echo "$values" | awk 'NR==2')"
  SECRET_KEY="$(echo "$values" | awk 'NR==3')"
  VPN_ENDPOINT="$(echo "$values" | awk 'NR==4')"
  PROXY_USER="$(echo "$values" | awk 'NR==5')"
  PROXY_PASS="$(echo "$values" | awk 'NR==6')"
  PROXY_HOST="$(echo "$values" | awk 'NR==7')"
  PROXY_PORT="$(echo "$values" | awk 'NR==8')"
else
  read -rp 'Enter your VPN username: ' VPN_USER
  read -rp 'Enter your VPN password: ' VPN_PASS
  read -rp 'Enter your VPN secret key: ' SECRET_KEY
  read -rp 'Enter your VPN endpoint: ' VPN_ENDPOINT
  read -rp 'Enter your PROXY username: [none] ' PROXY_USER
  read -rp 'Enter your PROXY password: [none] ' PROXY_PASS
  read -rp 'Enter your upstream remote PROXY IP address: ' PROXY_HOST
  read -rp 'Enter your upstream remote PROXY port: ' PROXY_PORT
fi

# Remove 'sed -i' for MacOS native compatibility:
sed "s/\\[VPN_USER\\]/$VPN_USER/" Dockerfile >tmp && mv tmp Dockerfile
sed "s/\\[VPN_PASS\\]/$VPN_PASS/" Dockerfile >tmp && mv tmp Dockerfile
sed "s/\\[SECRET_KEY\\]/$SECRET_KEY/" Dockerfile >tmp && mv tmp Dockerfile
sed "s/\\[PROXY_USER\\]/$PROXY_USER/" Dockerfile >tmp && mv tmp Dockerfile
sed "s/\\[PROXY_PASS\\]/$PROXY_PASS/" Dockerfile >tmp && mv tmp Dockerfile
sed "s/\\[PROXY_HOST\\]/$PROXY_HOST/" Dockerfile >tmp && mv tmp Dockerfile
sed "s/\\[PROXY_PORT\\]/$PROXY_PORT/" Dockerfile >tmp && mv tmp Dockerfile
sed "s/@@@@VPN_PASS@@@@/$VPN_PASS/g" scripts/dockervpn >tmp && mv tmp scripts/dockervpn
sed "s/@@@@PROXY_PASS@@@@/$PROXY_PASS/g" scripts/dockervpn >tmp && mv tmp scripts/dockervpn
sed "s@\\[VPN_ENDPOINT\\]@$VPN_ENDPOINT@g" scripts/vpn.sh >tmp && mv tmp scripts/vpn.sh
chmod +x scripts/dockervpn && chmod +x scripts/vpn.sh

echo -e '\nThe following commands may require your password for sudo.\n'

./uninstall.sh

if sudo docker build -t vpn .; then
  mkdir -p "${HOME}/share"
  echo -e '\nCopying easy startup scripts to /usr/local/bin...'
  echo -e '\nThe following commands may require your password for sudo.\n'
  sudo cp -v scripts/dockervpn /usr/local/bin/
  sudo chmod +x /usr/local/bin/dockervpn
  sudo cp -v scripts/sshvpn /usr/local/bin/
  sudo chmod +x /usr/local/bin/sshvpn
fi

# Sanitize Modified Installation Files:
sed "s/VPN_USER=${VPN_USER}/VPN_USER=\\[VPN_USER\\]/g" Dockerfile >tmp && mv tmp Dockerfile
sed "s/VPN_PASS=${VPN_PASS}/VPN_PASS=\\[VPN_PASS\\]/g" Dockerfile >tmp && mv tmp Dockerfile
sed "s/SECRET_KEY=${SECRET_KEY}/SECRET_KEY=\\[SECRET_KEY\\]/g" Dockerfile >tmp && mv tmp Dockerfile
sed "s/PROXY_USER=${PROXY_USER}/PROXY_USER=\\[PROXY_USER\\]/g" Dockerfile >tmp && mv tmp Dockerfile
sed "s/PROXY_PASS=${PROXY_PASS}/PROXY_PASS=\\[PROXY_PASS\\]/g" Dockerfile >tmp && mv tmp Dockerfile
sed "s/PROXY_HOST=${PROXY_HOST}/PROXY_HOST=\\[PROXY_HOST\\]/g" Dockerfile >tmp && mv tmp Dockerfile
sed "s/PROXY_PORT=${PROXY_PORT}/PROXY_PORT=\\[PROXY_PORT\\]/g" Dockerfile >tmp && mv tmp Dockerfile
sed "s/${VPN_PASS}/@@@@VPN_PASS@@@@/g" scripts/dockervpn >tmp && mv tmp scripts/dockervpn
sed "s/${PROXY_PASS}/@@@@PROXY_PASS@@@@/g" scripts/dockervpn >tmp && mv tmp scripts/dockervpn
sed "s@${VPN_ENDPOINT}@\\[VPN_ENDPOINT\\]@g" scripts/vpn.sh >tmp && mv tmp scripts/vpn.sh
chmod +x scripts/dockervpn && chmod +x scripts/vpn.sh

/usr/local/bin/dockervpn --help | head -9
