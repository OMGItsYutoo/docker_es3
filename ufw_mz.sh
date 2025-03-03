#!/bin/bash

# Install UFW
apt-get update
apt-get install -y ufw

# Default policies
ufw default deny incoming
ufw default deny outgoing

# Allow SSH
ufw allow in on eth0 to any port 22

# Allow HTTP and HTTPS traffic
ufw allow in on eth0 to any port 80
ufw allow in on eth0 to any port 443

# Allow MySQL traffic
ufw allow in on eth0 to any port 3306

# Ensure Docker follows UFW rules
iptables -I DOCKER-USER -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
iptables -I DOCKER-USER -m conntrack --ctstate INVALID -j DROP
iptables -I DOCKER-USER -j DROP

# Enable UFW
ufw --force enable

# Keep the container running
tail -f /dev/null