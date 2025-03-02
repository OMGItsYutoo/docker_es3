#!/bin/bash

# Install UFW
apt-get update
apt-get install -y ufw

# Installa dnsutils per ottenere il comando dig
apt-get install -y dnsutils

# Default policies
ufw default deny incoming
ufw default allow outgoing

# Allow SSH
ufw allow ssh

# Allow HTTP and HTTPS traffic
ufw allow 80/tcp
ufw allow 443/tcp

# Allow MySQL traffic
ufw allow 3306/tcp

#Block traffic to Facebook
IP_TO_BLOCK=$(dig +short facebook.com)
ufw deny out to $IP_TO_BLOCK

# Enable UFW
ufw --force enable

# Keep the container running
tail -f /dev/null