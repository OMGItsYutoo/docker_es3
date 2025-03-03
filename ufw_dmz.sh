#!/bin/bash

# Install necessary packages
apt-get update
apt-get install -y ufw dnsutils

# Set default firewall policies
ufw default deny incoming
ufw default allow outgoing

# Allow essential services
ufw allow ssh
ufw allow 80/tcp
ufw allow 443/tcp
ufw allow 3306/tcp

# Block Facebook - Handle multiple IPs
for ip in $(dig +short facebook.com); do
    ufw deny out to $ip
done

# Ensure Docker follows UFW rules
iptables -I DOCKER-USER -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
iptables -I DOCKER-USER -m conntrack --ctstate INVALID -j DROP
iptables -I DOCKER-USER -j DROP

# Enable UFW
ufw --force enable
ufw reload

echo "UFW firewall rules applied successfully."

# Keep the container running
tail -f /dev/null
