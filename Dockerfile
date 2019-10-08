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
FROM ubuntu:latest

ENV VPN_USER=[VPN_USER]
ENV VPN_PASS=[VPN_PASS]
ENV SECRET_KEY=[SECRET_KEY]
ENV PROXY_USER=[PROXY_USER]
ENV PROXY_PASS=[PROXY_PASS]
ENV PROXY_HOST=[PROXY_HOST]
ENV PROXY_PORT=[PROXY_PORT]
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get -y update && apt-get install -y --no-install-recommends \
    ca-certificates \
    tzdata \
    git \
    build-essential \
    autoconf \
    autotools-dev \
    automake \
    asciidoc \
    xsltproc \
    dnsutils \
    vim \
    less \
    inetutils-ping \
    inetutils-telnet \
    curl \
    proxychains \
    openssh-client \
    openconnect \
    oathtool \
    openvpn \
    vpnc-scripts \
    && git clone https://github.com/tinyproxy/tinyproxy.git \
    && cd tinyproxy \
    && groupadd nobody \
    && aclocal \
    && autoconf \
    && ./autogen.sh --enable-filter --enable-upstream --enable-transparent \
    && make \
    && make install \
    && apt-get remove --purge -y \
    git \
    build-essential \
    autoconf \
    autotools-dev \
    automake \
    asciidoc \
    xsltproc \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && apt-get clean

COPY scripts/vpn.sh /usr/local/bin/vpn
COPY scripts/entrypoint.sh /usr/local/bin/entrypoint

EXPOSE 8888

ENTRYPOINT ["/usr/local/bin/entrypoint"]
